---
layout: post
title: "Why I prefer using CRITICAL_SECTIONs for mutexes in Windows Nightly builds"
date: 2017-06-12 15:50:43 -0600
comments: true
categories: [Mozilla, Win32]
---
In the past I have argued that our Nightly builds, both debug and release, should
use `CRITICAL_SECTION`s (with full debug info) for our implementation of
`mozilla::Mutex`. I'd like to illustrate some reasons why this is so useful.

They enable more utility in WinDbg extensions
--------------------------------------------

Every time you initialize a `CRITICAL_SECTION`, Windows inserts the CS's
debug info into a process-wide linked list. This enables their discovery by
the Windows debugging engine, and makes the `!cs`, `!critsec`, and `!locks`
commands more useful.

They enable profiling of their initialization and acquisition
-------------------------------------------------------------

When the "Create user mode stack trace database" gflag is enabled, Windows
records the call stack of the thread that called `InitializeCriticalSection`
on that CS. Windows also records the call stack of the owning thread once
it has acquired the CS. This can be very useful for debugging deadlocks.

They track their contention counts
----------------------------------

Since every CS has been placed in a process-wide linked list, we may now ask
the debugger to dump statistics about every live CS in the process. In
particular, we can ask the debugger to output the contention counts for each
CS in the process. After running a workload against Nightly, we may then take
the contention output, sort it descendingly, and be able to determine which
`CRITICAL_SECTION`s are the most contended in the process.

We may then want to more closely inspect the hottest CSes to determine whether
there is anything that we can do to reduce contention and all of the extra
context switching that entails.

In Summary
----------

When we use `SRWLOCK`s or initialize our `CRITICAL_SECTION`s with the
`CRITICAL_SECTION_NO_DEBUG_INFO` flag, we are denying ourselves access to this
information. That's fine on release builds, but on Nightly I think it is worth 
having around. While I realize that most Mozilla developers have not used this
until now (otherwise I would not be writing this blog post), this rich debugger 
info is one of those things that you do not miss until you do not have it.

For further reading about critical section debug info, check out 
[this](https://web.archive.org/web/20150419055323/https://msdn.microsoft.com/en-us/magazine/cc164040.aspx) 
archived article from MSDN Magazine.
