---
layout: post
title: "New mozdbgext command: !iat"
date: 2016-02-11 18:30:00 -0700
comments: true
categories: [Mozilla, Debugging, Win32, mozdbgext]
---
As of today I have added a new command to `mozdbgext`: `!iat`.

The syntax is pretty simple:

`!iat <hexadecimal address>`

This address shouldn't be just any pointer; it should be the address of an
entry in the current module's import address table (IAT). These addresses
are typically very identifiable by the `_imp_` prefix in their symbol names.

The purpose of this extension is to look up the name of the DLL from whom the
function is being imported. Furthermore, the extension checks the expected
target address of the import with the actual target address of the import. This
allows us to detect API hooking via IAT patching.

### An Example Session

I fired up a local copy of Nightly, attached a debugger to it, and dumped the
call stack of its main thread:

<pre><samp>
 # ChildEBP RetAddr
00 0018ecd0 765aa32a ntdll!NtWaitForMultipleObjects+0xc
01 0018ee64 761ec47b KERNELBASE!WaitForMultipleObjectsEx+0x10a
02 0018eecc 1406905a USER32!MsgWaitForMultipleObjectsEx+0x17b
03 0018ef18 1408e2c8 xul!mozilla::widget::WinUtils::WaitForMessage+0x5a
04 0018ef84 13fdae56 xul!nsAppShell::ProcessNextNativeEvent+0x188
05 0018ef9c 13fe3778 xul!nsBaseAppShell::DoProcessNextNativeEvent+0x36
06 0018efbc 10329001 xul!nsBaseAppShell::OnProcessNextEvent+0x158
07 0018f0e0 1038e612 xul!nsThread::ProcessNextEvent+0x401
08 0018f0fc 1095de03 xul!NS_ProcessNextEvent+0x62
09 0018f130 108e493d xul!mozilla::ipc::MessagePump::Run+0x273
0a 0018f154 108e48b2 xul!MessageLoop::RunInternal+0x4d
0b 0018f18c 108e448d xul!MessageLoop::RunHandler+0x82
0c 0018f1ac 13fe78f0 xul!MessageLoop::Run+0x1d
0d 0018f1b8 14090f07 xul!nsBaseAppShell::Run+0x50
0e 0018f1c8 1509823f xul!nsAppShell::Run+0x17
0f 0018f1e4 1514975a xul!nsAppStartup::Run+0x6f
10 0018f5e8 15146527 xul!XREMain::XRE_mainRun+0x146a
11 0018f650 1514c04a xul!XREMain::XRE_main+0x327
12 0018f768 00215c1e xul!XRE_main+0x3a
13 0018f940 00214dbd firefox!do_main+0x5ae
14 0018f9e4 0021662e firefox!NS_internal_main+0x18d
15 0018fa18 0021a269 firefox!wmain+0x12e
16 0018fa60 76e338f4 firefox!__tmainCRTStartup+0xfe
17 0018fa74 77d656c3 KERNEL32!BaseThreadInitThunk+0x24
18 0018fabc 77d6568e ntdll!__RtlUserThreadStart+0x2f
19 0018facc 00000000 ntdll!_RtlUserThreadStart+0x1b
</samp></pre>

Let us examine the code at frame 3:

<pre><samp>
14069042 6a04            push    4
14069044 68ff1d0000      push    1DFFh
14069049 8b5508          mov     edx,dword ptr [ebp+8]
1406904c 2b55f8          sub     edx,dword ptr [ebp-8]
1406904f 52              push    edx
14069050 6a00            push    0
14069052 6a00            push    0
14069054 ff159cc57d19    call    dword ptr [xul!_imp__MsgWaitForMultipleObjectsEx (197dc59c)]
1406905a 8945f4          mov     dword ptr [ebp-0Ch],eax
</samp></pre>

Notice the function call to `MsgWaitForMultipleObjectsEx` occurs indirectly;
the call instruction is referencing a pointer within the `xul.dll` binary
itself. This is the IAT entry that corresponds to that function.

Now, if I load `mozdbgext`, I can take the address of that IAT entry and execute
the following command:

<pre><samp>
0:000> !iat 0x197dc59c
Expected target: USER32.dll!MsgWaitForMultipleObjectsEx
Actual target: USER32!MsgWaitForMultipleObjectsEx+0x0
</samp></pre>

`!iat` has done two things for us:

1. It did a reverse lookup to determine the module and function name for the
import that corresponds to that particular IAT entry; and
2. It followed the IAT pointer and determined the symbol at the target address.

Normally we want both the expected and actual targets to match. If they don't,
we should investigate further, as this mismatch may indicate that the IAT has
been patched by a third party.

Note that `!iat` command is breakpad aware (provided that you've already
loaded the symbols using `!bploadsyms`) but can fall back to the Microsoft
symbol engine as necessary.

Further note that the `!iat` command does not yet accept the `_imp_` symbolic
names for the IAT entries, you need to enter the hexadecimal representation of
the pointer.
