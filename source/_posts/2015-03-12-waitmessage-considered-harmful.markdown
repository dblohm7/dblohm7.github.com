---
layout: post
title: "WaitMessage Considered Harmful"
date: 2015-03-12 15:00:00 -0600
comments: true
categories: [Mozilla, Win32, Chromium]
---
I could apologize for the clickbaity title, but I won't. I have no shame.

Today I want to talk about some code that we imported from Chromium some time 
ago. I replaced it in Mozilla's codebase a few months back in {%bug 1072752%}:

{% include_code lang:c++ range:261-277 message_pump_win.cc %}

This code is wrong. **Very** wrong.

Let us start with the calls to `GetQueueStatus` and `PeekMessage`. Those APIs 
mark any messages already in the thread's message queue as having been seen, 
such that they are no longer considered "new." Even though those function calls 
do not remove messages from the queue, any messages that were in the queue at 
this point are considered to be "old."

The logic in this code snippet is essentially saying, "if the queue contains 
mouse messages that do not belong to this thread, then they must belong to an 
attached thread." The code then calls `WaitMessage` in an effort to give the 
other thread(s) a chance to process their mouse messages. This is where the code 
goes off the rails.

The [documentation](https://msdn.microsoft.com/en-us/library/windows/desktop/ms644956%28v=vs.85%29.aspx) 
for `WaitMessage` states the following:

> Note that `WaitMessage` does not return if there is unread input in the message 
> queue after the thread has called a function to check the queue. This is 
> because functions such as `PeekMessage`, `GetMessage`, `GetQueueStatus`,
> `WaitMessage`, `MsgWaitForMultipleObjects`, and `MsgWaitForMultipleObjectsEx` 
> check the queue and then change the state information for the queue so that 
> the input is no longer considered new. A subsequent call to `WaitMessage` will 
> not return until new input of the specified type arrives. The existing unread 
> input (received prior to the last time the thread checked the queue) is ignored.

`WaitMessage` will only return if there is *a new* (as opposed to *any*) message 
in the queue for the calling thread. Any messages for the calling thread that 
were already in there at the time of the `GetQueueStatus` and `PeekMessage` calls 
are no longer new, so they are ignored.

There might very well be a message at the head of that queue that should be 
processed by the current thread. Instead it is ignored while we wait for other 
threads. Here is the crux of the problem: we're waiting on other threads whose 
input queues are attached to our own! That other thread can't process its 
messages because our thread has messages in front of its messages; on the other 
hand, our thread has blocked itself!

The only way to break this deadlock is for new messages to be added to the queue.
That is a big reason why we're seeing things like {% bug 1105386 %}: Moving the 
mouse adds new messages to the queue, making `WaitMessage` unblock.

I've already eliminated this code in Mozilla's codebase, but the challenge is 
going to be getting rid of this code in third-party binaries that attach their 
own windows to Firefox's windows.

