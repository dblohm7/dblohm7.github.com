---
layout: post
title: "Interesting Win32 APIs"
date: 2015-07-28 11:30:00 -0600
comments: true
categories: [Mozilla, Win32]
---
Today I decided to diff the export tables of some core Win32 DLLs to see what's
changed between Windows 8.1 and the Windows 10 technical preview. There weren't
many changes, but the ones that were there are quite exciting IMHO. While
researching these new APIs, I also stumbled across some others that were
added during the Windows 8 timeframe that we should be considering as well.

Volatile Ranges
---------------

While my diff showed these APIs as new exports for Windows 10, the MSDN docs
claim that these APIS are actually new for the Windows 8.1 Update. Using the
[`OfferVirtualMemory`](https://msdn.microsoft.com/en-us/library/windows/desktop/dn781436%28v=vs.85%29.aspx)
and [`ReclaimVirtualMemory`](https://msdn.microsoft.com/en-us/library/windows/desktop/dn781437%28v=vs.85%29.aspx)
functions, we can now specify ranges of virtual memory that are safe to
discarded under memory pressure. Later on, should we request that access be
restored to that memory, the kernel will either return that virtual memory to us
unmodified, or advise us that the associated frames have been discarded.

A couple of years ago we had an intern on the Perf Team who was working on
bringing this capability to Linux. I am pleasantly surprised that this is now
offered on Windows.

`madvise(MADV_WILLNEED)` for Win32
----------------------------------

For the longest time we have been hacking around the absence of a `madvise`-like
API on Win32. On Linux we will do a `madvise(MADV_WILLNEED)` on memory-mapped
files when we want the kernel to read ahead. On Win32, we were opening the
backing file and then doing a series of sequential reads through the file to
force the kernel to cache the file data. As of Windows 8, we can now call
[`PrefetchVirtualMemory`](https://msdn.microsoft.com/en-us/library/windows/desktop/hh780543%28v=vs.85%29.aspx)
for a similar effect.

Operation Recorder: An API for SuperFetch
-----------------------------------------

The [`OperationStart`](https://msdn.microsoft.com/en-us/library/hh437562%28v=vs.85%29.aspx)
and [`OperationEnd`](https://msdn.microsoft.com/en-us/library/hh437558%28v=vs.85%29.aspx)
APIs are intended to record access patterns during a file I/O operation.
SuperFetch will then create prefetch files for the operation, enabling prefetch
capabilities above and beyond the use case of initial process startup.

Memory Pressure Notifications
-----------------------------

This API is not actually new, but I couldn't find any invocations of it in the
Mozilla codebase. [`CreateMemoryResourceNotification`](https://msdn.microsoft.com/en-us/library/windows/desktop/aa366541%28v=vs.85%29.aspx)
allocates a kernel handle that becomes signalled when physical memory is running
low. Gecko already has facilities for handling memory pressure events on other
platforms, so we should probably add this to the Win32 port.

