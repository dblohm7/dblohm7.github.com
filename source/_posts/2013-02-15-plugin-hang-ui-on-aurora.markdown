---
layout: post
title: "Plugin Hang UI on Aurora"
date: 2013-02-15 17:00
comments: true
categories: Mozilla, Plugins
---
The UI Has Landed
-----------------

The [Plugin Hang UI](http://dblohm7.ca/blog/2012/11/22/plugin-hang-user-interface-for-firefox/) 
landed in mozilla-central in time for January's merge. This means that it is 
now available on both Nightly and Aurora.

While it's great that this code is now available to a larger audience, there 
are consequences to this. :-)

Telemetry and Pref Adjustments
------------------------------

The first (and more pleasant) consequence is that we are now receiving telemetry 
about the UI's usage patterns. This allows us to make some adjustments as the 
Plugin Hang UI gets closer to the release channel. As happy as I am that this 
feature will be putting users in the driver's seat when dealing with hung 
plugins, it's also important to not annoy users.

Initially our telemetry suggested that the Plugin Hang UI frequently appeared
but then cancelled automatically because the plugin resumed execution. This 
indicated to us that we should increase the default value of the 
`dom.ipc.plugins.hangUITimeoutSecs` preference ([bug 833560](https://bugzilla.mozilla.org/show_bug.cgi?id=833560)).
There has also been some discussion about scaling the Hang UI threshold depending 
on hardware performance and user behaviour. This threshold is tricky to balance; 
while we want users to be able to terminate a hanging plugin, we want to provide 
that feature with minimal annoyance.

Crashes
-------

Another consequence of the feature landing is that we received reports from 
Nightly and Aurora showing that the Plugin Hang UI was inducing crashes in the 
browser itself. Unfortunately the only thing that the stack traces were telling
us was that the browser-side code that hosts out-of-process plugins was not 
being cleaned up properly after forcibly terminating the plugin container. We 
didn't have any steps to reproduce. What broke this mystery wide open was when 
our crash stats were finally able to show some correlations. I learned that 
nearly 50% of the crashes happened on single-core CPUs.

### The Problem

Once I was able to test this out for myself, the issue revealed itself in short order. 
Fortunately for me, even though the problem involved thread scheduling, I was still able 
to reproduce it in a debugger. [This patch](https://bugzilla.mozilla.org/show_bug.cgi?id=828034#c8)
took care of the problem.

There's a bit of nuance to what was happening with this crash. When 
`plugin-container.exe` is forcibly terminated, cleanup of the browser-facing 
plugin code may be executed in one of two different sequences:

### Sequence 1 (Most common)

1. After terminating `plugin-container.exe`, the Plugin Hang UI posts a 
`CleanupFromTimeout` work item to the main thread. Concurrently on the 
I/O thread, Firefox's `RPCChannel` detects an error and posts a 
`OnNotifyMaybeChannelError` work item.

2. `OnNotifyMaybeChannelError` executes and sets the channel's state to 
`ChannelError`. It also cleans up the `PluginModuleParent` actor and its 
actors for subprotocols.

3. `CleanupFromTimeout` runs and attempts to Close the channel. This 
is effectively a no-op since the channel was already closed with an 
error status by step 2.

### Sequence 2 (Less common unless running on fewer cores)

1. Same as above.

2. `CleanupFromTimeout` runs before `OnNotifyMaybeChannelError`. This 
work item attempts to do a regular `Close` on the channel. Since the 
channel's state is still set to `ChannelConnected`, the close operation 
doesn't realize that it needs to do additonal cleanup. It performs 
a clean shutdown of the RPC channel without properly cleaning up the 
IPDL actors.

3. `OnMaybeNotifyChannelError` runs, sees the channel is already closed 
due to the activities in step 2, and does nothing.

4. A crash later occurs because the actors were never cleaned up properly.

### Some Additional Analysis

Sequence 2 cannot crash if the `plugin-container.exe` process is terminated 
by the main thread. This is because `PluginModuleParent::ShouldContinueFromReplyTimeout` 
returns `false` in this case and the channel's state is set to `ChannelTimeout` by 
the time that the `CleanupFromTimeout` work item executes. This guarantees that 
a full cleanup will be done by `CleanupFromTimeout`.

With the Plugin Hang UI, `plugin-container.exe` is not terminated by the main 
thread, so the channel's state must be explicitly updated after termination.

### Solution

The patch modifies the `CleanupFromTimeout` work item so that if the 
plugin container was terminated outside the main thread, the channel is 
explicitly closed with an error state. This ensures that the actors are 
properly cleaned up.

Hangs
-----

I filed [bug 834127](https://bugzilla.mozilla.org/show_bug.cgi?id=834127) 
when QA discovered that sometimes the Plugin Hang UI was not being displayed. 
I found out that Firefox was correctly spawning `plugin-hang-ui.exe`, however 
it was not showing any UI.

This lead be back down the input queue rabbit hole that I briefly discussed 
last time. I learned that on an intermittent basis, the Plugin Hang UI dialog 
box was being hung up on Win32 `ShowWindow` and `SetFocus` calls. What I did 
know was that my attempts to explicitly detach the Plugin Hang UI's thread 
from the hung Firefox thread weren't working well as I would have liked.

After [numerous attempts](https://bugzilla.mozilla.org/show_bug.cgi?id=834127#c9) 
at fixing these issues, I determined that for the time being we will have to 
rescind the owner-owned relationship between Firefox and the Plugin Hang UI 
dialog. If we didn't do so, seemingly benign actions like a call to `PeekMessage` 
or passing a `WM_NCLBUTTONDOWN` message to `DefWindowProc` would be enough 
to bring the Plugin Hang UI to a halt. Why is this, you ask? I decided to 
peek into kernel mode to find out.

### Adventures in Kernel Mode

Recall that the guts of `USER32` and `GDI32` were moved into the kernel 
via `win32k.sys` in the Windows NT 3.5 timeframe. It follows that any 
efforts to examine Win32 internals necessitates peering into kernel mode. 
I didn't need an elaborate remote debugging setup for my purposes, so I 
used [Sysinternals LiveKd](http://technet.microsoft.com/en-us/sysinternals/bb897415)
to take a snapshot of my kernel and debug it.

My workflow was essentially as follows:

* Plugin Hang UI gets stuck
* Attach a debugger (I use WinDbg) to `plugin-hang-ui.exe`
* Run LiveKd
* Type `!thread -t <tid>` into the kernel debugger, where `<tid>` is the user-mode 
thread ID that is hung in the user-mode WinDbg

Every kernel-mode call stack that I examined on a hung thread usually ended up going through this code path:

<pre><samp>
...
Child-SP          RetAddr           : Args to Child                                                           : Call Site
fffff880`0def3ec0 fffff800`0327c652 : fffffa80`079c43c0 fffffa80`079c43c0 00000000`00000000 fffffa80`00000008 : nt!KiSwapContext+0x7a
fffff880`0def4000 fffff800`0328da9f : fffffd54`0000000c fffffd54`000002a0 000002ac`00000000 00000804`fffffd54 : nt!KiCommitThreadWait+0x1d2
fffff880`0def4090 fffff800`03278a14 : 00000000`00000000 00000000`00000005 00000000`00000000 fffff800`03279600 : nt!KeWaitForSingleObject+0x19f
fffff880`0def4130 fffff800`03279691 : fffffa80`079c43c0 fffffa80`079c4410 00000000`00000000 00000000`00000000 : nt!KiSuspendThread+0x54
fffff880`0def4170 fffff800`0327c85d : fffffa80`079c43c0 00000000`00000000 fffff800`032789c0 00000000`00000000 : nt!KiDeliverApc+0x201
fffff880`0def41f0 fffff800`0328da9f : fffffa80`0a7510e0 fffff800`0327c26f fffffa80`00000000 fffff800`03402e80 : nt!KiCommitThreadWait+0x3dd
fffff880`0def4280 fffff960`0010d457 : fffff900`c2255200 00000000`0000000d 00000000`00000001 00000000`00000000 : nt!KeWaitForSingleObject+0x19f
fffff880`0def4320 fffff960`0010d4f1 : fffff880`0def0000 fffff900`c08e0e20 00000000`00000000 00000000`00000000 : win32k!xxxRealSleepThread+0x257
fffff880`0def43c0 fffff960`000c46d3 : 00000000`00000000 fffff900`c093ee90 00000000`00000200 00000000`00000046 : win32k!xxxSleepThread+0x59
fffff880`0def43f0 fffff960`0010c53e : fffff900`c093ee90 fffff900`c08e0e20 00000000`00000000 fffff900`c25724b0 : win32k!xxxInterSendMsgEx+0x112a
fffff880`0def4500 fffff960`000d8ccf : fffff900`c25724b0 fffff900`c25724b0 <mark>00000000`003c031a</mark> fffff900`c0800b90 : win32k!xxxSendMessageTimeout+0x1de
fffff880`0def45b0 fffff960`000dae0b : fffff960`00000006 fffff880`0def47c0 fffff960`00000000 fffff900`00000000 : win32k!xxxCalcValidRects+0x1a3
fffff880`0def46f0 fffff960`000dac3a : fffff900`00000001 fffff900`c08e0e20 fffff880`0def49b8 fffff900`00000000 : win32k!xxxEndDeferWindowPosEx+0x18f
fffff880`0def47b0 fffff960`000d6e09 : 00000000`00000000 00000000`00000001 fffff900`00000000 fffff800`00000000 : win32k!xxxSetWindowPos+0x156
fffff880`0def4830 fffff960`0007c66d : fffff900`00000000 fffff900`0004366c fffff900`00000000 fffff900`c209f410 : win32k!xxxActivateThisWindow+0x441
...
</samp></pre>

The highlighted hexidecimal value above is a handle to a window with class 
`MSCTFIME UI` (i.e. a Microsoft IME window) that was created by the main 
UI thread in the hung Flash process. Despite my best efforts to try to 
disconnect the Plugin Hang UI input queue from these threads, Windows is 
insistent on sending a synchronous, inter-thread message to the IME window 
on the hung Flash thread. This doesn't happen if we omit setting Firefox's
`HWND` as the Plugin Hang UI's owner window.

### Implications

Now that the Plugin Hang UI specifies a `NULL` owner, Windows can no longer 
guarantee that the Plugin Hang UI will always appear above the Firefox window 
that was active at the time that the plugin hang occurred. Having said that, 
our experiments have shown that Windows does not try to promote an unresponsive 
window to the front of the Z-order.

In a multiple-window situation, Windows may move the other, inactive Firefox 
windows ahead of the Plugin Hang UI in the Z-order, but the window that was 
active when Firefox first hung does not move. I think that this is acceptable. 
In fact, the same behavour would be observable if we had been able to specify 
an owner.

If you're interested in helping to test this feature, please install Nightly 
and try the repro from [bug 834127](https://bugzilla.mozilla.org/show_bug.cgi?id=834127#c0).
When the Plugin Hang UI fires, try to move around the Plugin Hang UI as well 
as the other windows on your desktop, including Firefox. If the windows change 
the Z-order differently from the way that I have observed here, please try to 
generate some steps to reproduce, drop me a line (aklotz on `#perf` or MoCo email) 
and let me know what's going on. Thanks!
