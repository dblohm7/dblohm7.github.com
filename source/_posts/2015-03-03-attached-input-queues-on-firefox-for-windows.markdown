---
layout: post
title: "Attached Input Queues on Firefox for Windows"
date: 2015-03-03 17:28:06 -0700
comments: true
categories: [Mozilla, Win32, Undocumented Windows]
---
I've [previously](http://dblohm7.ca/blog/2012/11/22/plugin-hang-user-interface-for-firefox/) [blogged](http://dblohm7.ca/blog/2013/02/15/plugin-hang-ui-on-aurora/) 
indirectly about attached input queues, but today I want to address the issue directly. What once was a nuisance in the realm of plugin hangs has grown into a more 
serious problem in the land of OMTC and e10s.

As a brief recap for those who are not very familiar with this problem: imagine two windows, each on their own separate threads, forming a parent-child relationship 
with each other. When this situation arises, Windows implicitly attaches together and synchronizes their input queues, putting each thread at the mercy of the other 
attached threads' ability to pump messages. If one thread does something bad in its message pump, any other threads that are attached to it are likely to be affected as well.

One of the biggest annoyances when it comes to knowledge about which threads are affected, is that we are essentially flying blind. There is no 
way to query Windows for information about attached input queues. This is unfortunate, as it would be really nice to obtain some specific knowledge to allow us to 
analyze the state of Firefox threads' input queues so that we can mitigate the problem.

I had previously been working on a personal side project to make this possible, but in light of recent developments (and a [tweet from bsmedberg](https://twitter.com/nsIAnswers/status/565883284748795905)), 
I decided to bring this investigation under the umbrella of my full-time job. I'm pleased to announce that I've finished the first cut of a utility that I call 
the Input Queue Visualizer, or `iqvis`.

`iqvis` consists of two components, one of which is a kernel-mode driver. This driver exposes input queue attachment data to user mode. The `iqvis` user-mode 
executable is the client that queries the driver and outputs the results. In the next section I'm going to discuss the inner workings of `iqvis`. Following that, I'll 
discuss the [results](#results) of running `iqvis` on an instance of Firefox.

<a name="internals"></a>Input Queue Visualizer Internals
--------------------------------

First of all, let's start off with this caveat: **Nearly everything that this driver does involves undocumented APIs and data structures**. Because of this, `iqvis` 
does some things that you should never do in production software.

One of the big consequences of using undocumented information is that `iqvis` requires pointers to very specific locations 
in kernel memory to accomplish things. These pointers will change every time that Windows is updated. To mitigate this, I kind of cheated: it turns out that 
debugging symbols exist for all of the locations that `iqvis` needs to access! I wrote the `iqvis` client to invoke the `dbghelp` engine to extract the pointers that 
I need from Windows symbols and send those values as the input to the `DeviceIoControl` call that triggers the data collection. Passing pointers from user mode to be 
accessed in kernel mode is a very dangerous thing to do (and again, I would never do it in production software), but it is damn convenient for `iqvis`!

Another issue is that these undocumented details change between Windows versions. The initial version of `iqvis` works on 64-bit Windows 8.1, but different code is required 
for other major releases, such as Windows 7. The `iqvis` driver theoretically will work on Windows 7 but I need to make a few bug fixes for that case.

So, getting those details out of the way, we can address the crux of the problem: we need to query input queue attachment information from `win32k.sys`, which is the 
driver that implements USER and GDI system calls on Windows NT systems.

In particular, the window manager maintains a linked list that describes thread attachment info as a triple that points to the "from" thread, the "to" thread, and a count. 
The count is necessary because the same two threads may be attached to each other multiple times. The `iqvis` driver walks this linked list in a thread-safe way to obtain 
the attachment data, and then copies it to the output buffer for the `DeviceIoControl` request.

Since `iqvis` involves a device driver, and since I have not digitally signed that device driver, one can't just run `iqvis` and call it a day. This program won't work 
unless the computer was either booted with kernel debugging enabled, or it was booted with driver signing temporarily disabled.

<a name="results"></a>Running `iqvis` against Firefox
-------------------------------

Today I ran `iqvis` using today's Nightly 39 as well as the lastest release of Flash. I also tried it with Flash Protected Mode both disabled and enabled.
(Note that these examples used an older version of `iqvis` that outputs thread IDs in hexadecimal. The current version uses decimal for its output.)

### Protected Mode Disabled

<pre><samp>FromTID ToTID Count
ac8 df4 1
</samp></pre>

Looking up the thread IDs:

* `df4` is the Firefox main thread;
* `ac8` is the plugin-container main thread.

I think that the output from this case is pretty much what I was expecting to see. The protected mode case, however, is more interesting.

### Protected Mode Enabled

<pre><samp>FromTID ToTID Count
f8c dbc 1
794 f8c 3
</samp></pre>

Looking up the thread IDs:

* `dbc` is the Firefox main thread;
* `f8c` is the plugin-container main thread;
* `794` is the Flash sandbox main thread.

Notice how Flash is attached to plugin-container, which is then attached to Firefox. Notice that transitively the Flash sandbox is effectively attached to Firefox, 
confirming previous hypotheses that I've discussed with colleagues in the past.

Also notice how the Flash sandbox attachment to plugin-container has a count of 3!

In Conclusion
-------------

In my opinion, my Input Queue Visualizer has already yielded some very interesting data. Hopefully this will help us to troubleshoot our issues in the future. Oh, 
and the code is up on [GitHub](https://github.com/dblohm7/iqvis)! It's poorly documented at the moment, but just remember to only try running it on 64-bit Windows 
8.1 for the time being!

