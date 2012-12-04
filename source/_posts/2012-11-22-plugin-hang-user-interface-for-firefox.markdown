---
layout: post
title: "Plugin Hang User Interface for Firefox"
date: 2012-11-22 10:22
comments: true
categories: [Win32, Plugins, New Features]
---
My first significant project at Mozilla has been 
[bug 805591](https://bugzilla.mozilla.org/show_bug.cgi?id=805591), 
implementing a user interface to be displayed by Firefox when 
an out-of-process plugin hangs. This is important because when NPAPI 
plugins hang, they block the main thread in Firefox. When the main 
thread is blocked, the Firefox user interface grinds to a halt.

The purpose of the Plugin Hang UI is twofold:

* To inform the user which plugin is responsible for the hang; and
* Provide the user with an opportunity to terminate the plugin if he/she wishes.


Currently this is feature is exclusive to Firefox Desktop on Windows. 
When the Hang UI is invoked, you'll notice that Firefox has created 
a new child process, plugin-hang-ui.exe. This child process will 
display the Plugin Hang UI dialog box.

{% img http://dblohm7.ca/images/hangui.png %}

My patch is currently under review, but the Plugin Hang UI is fully functional 
in a [try build](http://ftp.mozilla.org/pub/mozilla.org/firefox/try-builds/aklotz@mozilla.com-f5d8fdf4f29a/try-win32/firefox-19.0a1.en-US.win32.installer.exe), 
so please check it out and play with it!

Changes to Preferences
----------------------

* `dom.ipc.plugins.hangUITimeoutSecs`: This is the number of seconds 
that Firefox waits for a hung plugin before displaying the Plugin Hang UI.
Setting this value to zero disables the Plugin Hang UI.

* `dom.ipc.plugins.timeoutSecs`: This pref is still used with the Hang UI,
but its semantics change a little bit. Once the Plugin Hang UI has been 
displayed, Firefox will wait `dom.ipc.plugins.timeoutSecs` seconds before 
terminating the plugin automatically, even if the user did not elect to 
stop the plugin using the Hang UI. This is nearly identical to the way that 
Firefox behaves without the Hang UI -- the only difference is that now this 
timeout period doesn't commence until the Hang UI is displayed.

* `dom.ipc.plugins.hangUIMinDisplaySecs`: This is the minimum number 
of seconds that Firefox should display the Plugin Hang UI. If 
`dom.ipc.plugins.timeoutSecs` is set to a value lower than this 
pref, the Hang UI is disabled. The idea here is that, if 
`dom.ipc.plugins.timeoutSecs` is only set to 5 seconds to begin with, 
then the plugin will already have been auto terminated before the 
user has half a chance to read the Plugin Hang UI.

Implementation Details
----------------------

There are a couple of interesting things that I'd like to point out 
relating to this patch.

Because the Plugin Hang UI is a child process, I needed to ensure that 
its window always appears in front of the hung Firefox window. I decided 
that I would have Firefox send its top-level `HWND` over to the child 
process so that the Hang UI could specify that handle as the owner of its 
top-level window. If you've seen [Raymond Chen's](http://blogs.msdn.com/b/oldnewthing) 
[Five Things Every Win32 Programmer Needs to Know](http://channel9.msdn.com/Blogs/scobleizer/Raymond-Chen-PDC-05-Talk-Five-Things-Every-Win32-Programmer-Needs-to-Know), 
then you'll know what is coming: Deadlock!

The problem is that the Hang UI window and the Firefox window are 
created by different threads. When I set the owner relationship 
between the Hang UI top-level window and the Firefox top-level window, 
the window manager implicitly synchronizes both threads' input queues.
In the case of the Plugin Hang UI, this is a huge problem: Windows just 
synchronized the Hang UI's input queue with a hung thread!

What's the solution, then? Think about it this way: the window manager 
might have implicitly synchronized the two threads' input queues, but 
there's no reason why we can't then *explicitly* desynchronize them!

Here's the first thing I do in the Plugin Hang UI's `WM_INITDIALOG` handler:

{% codeblock lang:cpp %}
      // Disentangle our input queue from the hung Firefox process
      AttachThreadInput(GetCurrentThreadId(),
                        GetWindowThreadProcessId(mParentWindow, nullptr),
                        FALSE);
{% endcodeblock %}

Without this line, the Hang UI is at risk of deadlock. This is 
especially true if the user attempts to send input to the Firefox 
window underneath.
