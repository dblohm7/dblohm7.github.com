---
layout: post
title: "Bugs from Hell: Injected Third-party Code + Detours = A Bad Time"
date: 2016-01-11 13:00:00 -0700
comments: true
categories: [Mozilla, Debugging, DLL Injection, Win32]
---
Happy New Year!

I'm finally getting 'round to writing about a nasty bug that I had to spend a
bunch of time with in Q4 2015. It's one of the more challenging problems that
I've had to break and I've been asked a lot of questions about it. I'm talking
about {%bug 1218473%}.

How This All Began
------------------

In {%bug 1213567%} I had landed a patch to intercept calls to `CreateWindowEx`.
This was necessary because it was apparent in that bug that window subclassing
was occurring while a window was neutered ("neutering" is terminology that is
specific to Mozilla's Win32 IPC code).

While I'll save a discussion on the specifics of window neutering for another
day, for our purposes it is sufficient for me to point out that subclassing a
neutered window is bad because it creates an infinite recursion scenario with
window procedures that will eventually overflow the stack.

Neutering is triggered during certain types of IPC calls as soon as a message is
sent to an unneutered window on the thread making the IPC call. Unfortunately in
the case of {%bug 1213567%}, the message triggering the neutering was
`WM_CREATE`. Shortly after creating that window, the code responsible would
subclass said window. Since `WM_CREATE` had already triggered neutering, this
would result in the pathological case that triggers the stack overflow.

For a fix, what I wanted to do is to prevent messages that were sent immediately
during the execution of `CreateWindow` (such as `WM_CREATE`) from triggering
neutering prematurely. By intercepting calls to `CreateWindowEx`, I could wrap
those calls with a RAII object that temporarily suppresses the neutering. Since
the subclassing occurs immediately after window creation, this meant that
this subclassing operation was now safe.

Unfortunately, shortly after landing {%bug 1213567%}, {%bug 1218473%} was filed.

Where to Start
--------------

It wasn't obvious where to start debugging this. While a crash spike was clearly
correlated with the landing of {%bug 1213567%}, the crashes were occurring in
code that had nothing to do with IPC or Win32. For example, the first stack that
I looked at was `js::CreateRegExpMatchResult`!

When it is just not clear where to begin, I like to start by looking at our
correlation data in Socorro -- you'd be surprised how often they can bring
problems into sharp relief!

In this case, the correlation data didn't disappoint: there
[was](https://bugzilla.mozilla.org/show_bug.cgi?id=1218473#c10) 100% correlation
with a module called `_etoured.dll`. There was also correlation with the
presence of both NVIDIA video drivers *and* Intel video drivers. Clearly this
was a concern only when NVIDIA Optimus technology was enabled.

I also had a pretty strong hypothesis about what `_etoured.dll` was: For many
years, Microsoft Research has shipped a package called
[Detours](http://research.microsoft.com/en-us/projects/detours/). Detours is a
library that is used for intercepting Win32 API calls. While the changelog for
Detours 3.0 points out that it has "Removed [the] requirement for including
`detoured.dll` in processes," in previous versions of the package, this library
was required to be injected into the target process.

I concluded that `_etoured.dll` was most likely a renamed version of
`detoured.dll` from Detours 2.x.

Following The Trail
-------------------

Now that I knew the likely culprit, I needed to know how it was getting there.
During a November trip to the Mozilla Toronto office, I spent some time
debugging a test laptop that was configured with Optimus.

Knowing that the presence of Detours was somehow interfering with our own API
interception, I decided to find out whether it was also trying to intercept
`CreateWindowExW`. I launched `windbg`, started Firefox with it, and then told
it to break as soon as `user32.dll` was loaded:

<pre><samp>
sxe ld:user32.dll
</samp></pre>

Then I pressed `F5` to resume execution. When the debugger broke again, this
time `user32` was now in memory. I wanted the debugger to break as soon as
`CreateWindowExW` was touched:

<pre><samp>
ba w 4 user32!CreateWindowExW
</samp></pre>

Once again I resumed execution. Then the debugger broke on the memory access and
gave me this call stack:

<pre><samp>
nvd3d9wrap!setDeviceHandle+0x1c91
nvd3d9wrap!initialise+0x373
nvd3d9wrap!setDeviceHandle+0x467b
nvd3d9wrap!setDeviceHandle+0x4602
ntdll!LdrpCallInitRoutine+0x14
ntdll!LdrpRunInitializeRoutines+0x26f
ntdll!LdrpLoadDll+0x453
ntdll!LdrLoadDll+0xaa
mozglue!`anonymous namespace'::patched_LdrLoadDll+0x1b0
KERNELBASE!LoadLibraryExW+0x1f7
KERNELBASE!LoadLibraryExA+0x26
kernel32!LoadLibraryA+0xba
nvinit+0x11cb
nvinit+0x5477
nvinit!nvCoprocThunk+0x6e94
nvinit!nvCoprocThunk+0x6e1a
ntdll!LdrpCallInitRoutine+0x14
ntdll!LdrpRunInitializeRoutines+0x26f
ntdll!LdrpLoadDll+0x453
ntdll!LdrLoadDll+0xaa
mozglue!`anonymous namespace'::patched_LdrLoadDll+0x1b0
KERNELBASE!LoadLibraryExW+0x1f7
kernel32!BasepLoadAppInitDlls+0x167
kernel32!LoadAppInitDlls+0x82
USER32!ClientThreadSetup+0x1f9
USER32!__ClientThreadSetup+0x5
ntdll!KiUserCallbackDispatcher+0x2e
GDI32!GdiDllInitialize+0x1c
USER32!_UserClientDllInitialize+0x32f
ntdll!LdrpCallInitRoutine+0x14
ntdll!LdrpRunInitializeRoutines+0x26f
ntdll!LdrpLoadDll+0x453
ntdll!LdrLoadDll+0xaa
mozglue!`anonymous namespace'::patched_LdrLoadDll+0x1b0
KERNELBASE!LoadLibraryExW+0x1f7
firefox!XPCOMGlueLoad+0x23c
firefox!XPCOMGlueStartup+0x1d
firefox!InitXPCOMGlue+0xba
firefox!NS_internal_main+0x5c
firefox!wmain+0xbe
firefox!__tmainCRTStartup+0xfe
kernel32!BaseThreadInitThunk+0xe
ntdll!__RtlUserThreadStart+0x70
ntdll!_RtlUserThreadStart+0x1b
</samp></pre>

This stack is a gold mine of information. In particular, it tells us the
following:

1. The offending DLLs are being injected by `AppInit_DLLs` (and in fact, Raymond
Chen [has blogged about](https://blogs.msdn.microsoft.com/oldnewthing/20140422-00/?p=1173)
this exact case in the past).

2. `nvinit.dll` is the name of the DLL that is injected by step 1.

3. `nvinit.dll` loads `nvd3d9wrap.dll` which then uses Detours to patch
our copy of `CreateWindowExW`.

I then became curious as to which other functions they were patching.

Since Detours is patching executable code, we know that at some point it is
going to need to call `VirtualProtect` to make the target code writable. In the
worst case, `VirtualProtect`'s caller is going to pass the address of the page
where the target code resides. In the best case, the caller will pass in the
address of the target function itself!

I restarted `windbg`, but this time I set a breakpoint on `VirtualProtect`:

<pre><samp>
bp kernel32!VirtualProtect
</samp></pre>

I then resumed the debugger and examined the call stack every time it broke.
While not every single `VirtualProtect` call would correspond to a detour, it
would be obvious when it was, as the NVIDIA DLLs would be on the call stack.

The first time I caught a detour, I examined the address being passed to
`VirtualProtect`: I ended up with the best possible case: the address was
pointing to the actual target function! From there I was able to distill a
[list](https://bugzilla.mozilla.org/show_bug.cgi?id=1218473#c39) of other
functions being hooked by the injected NVIDIA DLLs.

Putting it all Together
-----------------------

By this point I knew who was hooking our code and knew how it was getting there.
I also noticed that `CreateWindowEx` is the only function that the NVIDIA DLLs
and our own code were both trying to intercept. Clearly there was some kind of
bad interaction occurring between the two interception mechanisms, but what was
it?

I decided to go back and examine a
[specific](https://crash-stats.mozilla.com/report/index/e884dc17-957f-4270-86ab-f59742151113)
crash dump. In particular, I wanted to examine three different memory locations:

1. The first few instructions of `user32!CreateWindowExW`;
2. The first few instructions of `xul!CreateWindowExWHook`; and
3. The site of the call to `user32!CreateWindowExW` that triggered the crash.

Of those three locations, the only one that looked off was location 2:

<pre><samp>
6b1f6611 56              push    esi
6b1f6612 ff15f033e975    call    dword ptr [combase!CClassCache::CLSvrClassEntry::GetDDEInfo+0x41 (75e933f0)]
6b1f6618 c3              ret
6b1f6619 7106            jno     xul!`anonymous namespace'::CreateWindowExWHook+0x6 (6b1f6621)
xul!`anonymous namespace'::CreateWindowExWHook:
6b1f661b cc              int     3
6b1f661c cc              int     3
6b1f661d cc              int     3
6b1f661e cc              int     3
6b1f661f cc              int     3
6b1f6620 cc              int     3
6b1f6621 ff              ???
</samp></pre>

*Why the hell were the first six bytes filled with breakpoint instructions?*

I decided at this point to look at some source code. Fortunately Microsoft
publishes the 32-bit source code for Detours, licensed for non-profit use,
under the name "Detours Express."

I found a copy of Detours Express 2.1 and checked out the code. First I wanted
to know where all of these `0xcc` bytes were coming from. A quick `grep` turned
up what I was looking for:

``` c++ detours.cpp start:93
inline PBYTE detour_gen_brk(PBYTE pbCode, PBYTE pbLimit)
{
    while (pbCode < pbLimit) {
        *pbCode++ = 0xcc;   // brk;
    }
    return pbCode;
}
```

Now that I knew which function was generating the `int 3` instructions, I then
wanted to find its callers. Soon I found:

``` c++ detours.cpp start:1247
#ifdef DETOURS_X86
    pbSrc = detour_gen_jmp_immediate(pTrampoline->rbCode + cbTarget, pTrampoline->pbRemain);
    pbSrc = detour_gen_brk(pbSrc,
                           pTrampoline->rbCode + sizeof(pTrampoline->rbCode));
#endif // DETOURS_X86
```

Okay, so Detours writes the breakpoints out immediately after it has written a
`jmp` pointing to its trampoline.

*Why is our hook function being trampolined?*

The reason must be because our hook was installed first! Detours has
detected that and has decided that the best place to trampoline to the NVIDIA
hook is at the beginning of our hook function.

*But Detours is using the wrong address!*

We can see that because the `int 3` instructions are written out at the
*beginning* of `CreateWindowExWHook`, even though there should be a `jmp`
instruction first.

**Detours is calculating the wrong address to write its `jmp`!**

Finding a Workaround
--------------------

Once I knew *what* the problem was, I needed to know more about the *why* --
only then would I be able to come up with a way to work around this problem.

I decided to reconstruct the scenario where both our code and Detours are trying
to hook the same function, but our hook was installed first. I would then
follow along through the Detours code to determine how it calculated the wrong
address to install its `jmp`.

The first thing to keep in mind is that Mozilla's function interception code
takes advantage of [hot-patch points](https://blogs.msdn.microsoft.com/oldnewthing/20110921-00/?p=9583)
in Windows. If the target function begins with a `mov edi, edi` prolog, we
use a hot-patch style hook instead of a trampoline hook. I am not going to go
into detail about hot-patch hooks here -- the above Raymond Chen link contains
enough details to answer your questions. For the purposes of this blog post, the
important point is that Mozilla's code patches the `mov edi, edi`, so NVIDIA's
Detours library would need to recognize and follow the `jmp`s that our code
patched in, in order to write its own `jmp` at `CreateWindowExWHook`.

Tracing through the Detours code, I found the place where it checks for a
hot-patch hook and follows the `jmp` if necessary. While examining a function
called `detour_skip_jmp`, I found the bug:

``` c++ detours.cpp start:124
            pbNew = pbCode + *(INT32 *)&pbCode[1];
```

This code is supposed to be telling Detours where the target address of a `jmp`
is, so that Detours can follow it. `pbNew` is supposed to be the target address
of the `jmp`. `pbCode` is referencing the address *of the beginning of the `jmp`
instruction itself*. Unfortunately, with this type of `jmp` instruction, target
addresses are always relative to the address of the *next* instruction, not
the *current* instruction! Since the current `jmp` instruction is five bytes
long, Detours ends up writing its `jmp` *five bytes prior* to the intended
target address!

I went and checked the source code for Detours Express 3.0 to see if this had
been fixed, and indeed it had:

``` c++ detours.cpp start:163
            PBYTE pbNew = pbCode + 5 + *(INT32 *)&pbCode[1];
```

That doesn't do much for me right now, however, since the NVIDIA stuff is still
using Detours 2.x.

In the case of Mozilla's code, there is legitimate executable code at that
incorrect address that Detours writes to. It is corrupting the last few
instructions of that function, thus explaining those mysterious crashes that
were seemingly unrelated code.

I confirmed this by downloading the binaries from the build that was associated
with the crash dump that I was analyzing. [As an aside, I should point out that
you need to grab the *identical* binaries for this exercise; you cannot build
from the same source revision and expect this to work due to variability that
is introduced into builds by things like PGO.]

The five bytes preceeding `CreateWindowExHookW` in the crash dump diverged from
those same bytes in the original binaries. I could also make out that the
overwritten bytes consisted of a `jmp` instruction.

### In Summary

Let us now review what we know at this point:

* Detours 2.x doesn't correctly follow `jmp`s from hot-patch hooks;
* If Detours tries to hook something that has already been hot-patched
(including legitimate hot patches from Microsoft), it will write bytes at
incorrect addresses;
* NVIDIA Optimus injects this buggy code into everybody's address spaces via an
`AppInit_DLLs` entry for `nvinit.dll`.

How can we best distill this into a suitable workaround?

One option could be to block the NVIDIA DLLs outright. In most cases this would
probably be the simplest option, but I was hesitant to do so this time. I was
concerned about the unintended consequences of blocking what, for better or
worse, is a user-mode component of NVIDIA video drivers.

Instead I decided to take advantage of the fact that we now know how this bug is
triggered. I have modified our API interception code such that if it detects
the presence of NVIDIA Optimus, it disables hot-patch style hooks.

Not only will this take care of the crash spike that started when I landed
{% bug 1213567%}, I also expect it to take care of other crash signatures
whose relationship to this bug was not obvious.

That concludes this episode of *Bugs from Hell*. Until next time...
