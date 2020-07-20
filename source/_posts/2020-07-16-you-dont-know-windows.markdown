---
layout: post
title: "You Don't Know Windows"
date: 2020-07-16 11:16:47 -0600
comments: true
categories: [Mozilla, Win32]
---
Even though I no longer work on the Windows port of Gecko as part of my
full-time responsibilities at Mozilla, I still dabble here and there, and I
still review a lot of Windows-specific code. I thought I'd throw together a
post that provides some "essential Windows" guidance for other Gecko
developers.

Who This Post Is Intended For
-----------------------------
This post is intended for open-source developers who have a good generic
understanding of operating systems, come from a UNIX-y background, but must
maintain a cross-platform project that includes Windows-specific code. I
intend for this post to give you just enough high-level background to help you
make better decisions when it comes to code that affects Windows-specific
components.

This post is *not* a guide on how to build a Windows program from scratch.
Instead, this post assumes that your project has some expert Windows developers
who have done the heavy lifting when it comes to building out the essential
infrastructure.

If you *are* a Windows expert, perhaps you have a different idea of what needs
to be included in this guide. If so, I would strongly encourage you to
contribute a post of your own!

Other Caveats
-------------
As with anything I do in my talks or writings, what I say is "correct enough"
for the purposes of this discussion. If anybody wants to be pedantic about what
I write here, please comment somewhere else -- this post is *not* for you!

In the context of this post, when I say "Windows," I generally mean Windows
versions that are based on the NT kernel. Furthermore, I will generally be
referring to the Windows versions that are still supported by Gecko, so what I
write will generally be true for Windows 7 and newer.

When I refer to 16-bit Windows, I am generally referring to the consumer
versions of Windows that were released prior to Windows 95 [*While Windows 95
was not purely 32-bit, its first-class API *was* 32-bit*].

When I do discuss Windows versions that fall outside these parameters, I will
explicitly call that out.

Table of Contents
-----------------
I have placed anchors at each topic to help assist you with navigating this
document in the hope that, if you don't have the time or willpower to read the
entire thing at once, you'll at least be able to come and go as you please.

* [Windows Is Not Unix](#notunix)
* [Why Does Windows Do *x*?](#whydoeswin)
    * [A Note on Backward Compatibility](#backcompat)
* [NT Basics](#ntbasics)
    * [Nomenclature](#ntnomenclature)
    * [Userspace Fundamentals](#ntuserspace)
        * [Corallaries](#ntcorallaries)
    * [Virtual Memory Management](#ntvm)
    * [I/O](#ntio)
    * [Exception Handling](#seh)
* ["Kernel Handles" vs Other Handles](#handles)
* [Window Messaging](#hwnd)
* [COM](#com)

Hey, Ho, Let's Go!
------------------

<a name="notunix"></a>
## Windows Is Not Unix
Obviously this is self-evident, but hear me out: In my experience, many
developers coming from Unix backgrounds simply do not realize just how much of
their perceived "generic" understanding of modern operating systems is actually
Unix-specific (or even Linux-specific), and it leaves them with blind spots
where they assume that *all* modern operating systems do things the same way
that Unix does. Hopefully some of the topics that I describe in this document
will both surprise you, as well as help you to correct your own assumptions!

<a name="whydoeswin"></a>
## Why Does Windows Do *`x`*?
My high school biology teacher (Hi Mr. McFarlane!) used to tell my class that,
when trying to understand the physical shapes of biological structures, in the
absence of a better reason, we can usually attribute it to maximizing the
structure's surface area!

Analagous reasoning applies to Windows: If Windows does something in a way that
seems strange to you, 99% of the time you can probably attribute it to
maintaining backward compatibility!

<a name="backcompat"></a>
### A Note on Backward Compatibility
Note that when I say, "backward compatibility," I don't just mean ABI and API
compatibility with the first release of the Win32 API. I also mean
*source compatibility* for applications that were originally written for 16-bit
Windows! While the ABI is obviously different, a core design goal behind the
Win32 API was to minimize the amount of effort needed to port applications from
16-bit Windows to the (then) 32-bit Windows NT. Obviously the newer API needs to
provide similar semantics to the older API to facilitate this.

As you can probably imagine, transitioning from a 16-bit, co-operatively
multitasking system with minimal memory protection, to a modern, 32-bit,
preemptively multitasking OS with true memory protection, while preserving
source compatibility, required some major feats of engineering in certain
cases!

<a name="ntbasics"></a>
## NT Basics

<a name="ntnomenclature"></a>
### Nomenclature
* Shared libraries are known on Windows as dynamic-link libraries (DLLs) and
  unsurprisingly their file names end with the `.dll` extension.
* Windows binaries use a COFF-derived executable format known as Portable
  Executable (PE). This format is [fully documented](https://docs.microsoft.com/en-us/windows/win32/debug/pe-format)
  and its headers are included in the Windows SDK (see `winnt.h`).

<a name="ntuserspace"></a>
### Userspace Fundamentals

The NT kernel was designed around the concept of "personalities." The idea is
essentially that a machine running NT may have multiple distinct userspaces,
each with their own unique API and semantics. In fact, during its early
development, NT's original userspace personality was intended to be OS/2!
Eventually NT's first-class personality was switched over to Windows, and that
userspace became known as Win32. Note that the name "Win32" does not just
encompass the API surface itself, but also any other OS services and device
drivers needed to furnish the API's functionality.

The userspace components that constitute a personality vary depending on the
implementation of the personality itself, but the easiest high-level way to
envision this is that NT provides a "native API" that supplies the C stubs for
its system call interface. Ideally, however, user-mode programs never call this
interface directly. Instead, each personality provides a set of shim libraries
that expose the userspace "system call" API for that personality. The shims then
convert or forward calls made to personality API over to the native API.

Concretely, every NT process automatically has a dynamically-linked library
named `ntdll.dll` mapped into it. This library contains, among other things,
the following essential facilities:

*   **C stubs for NT's native system calls:**<br>
    As I mentioned above, user-mode applications usually do not directly call
    these. Instead, your application and its C runtime library both call into
    the *user-mode personality's* APIs.
*   **The user-mode heap manager:**<br>
    Since this is built into `ntdll.dll`, and since neither `ntdll` nor the PE
    executable format provide any hooks for overriding it, the heap manager is
    not replaceable on a process-wide basis!
*   **The dynamic loader and linker:**<br>
    Since this is built into `ntdll.dll`, and since neither `ntdll` nor the PE
    executable format provide any hooks for overriding it, this compoonent is
    not replaceable on a process-wide basis!
*   **The entry points for user-mode threads and final user-mode process initialization:**<br>
    These routines do any NT-specific initialization, then call into the
    personality's entry points to do personality-specific initialization,
    which then in turn finally call into your application's entry points.

TODO ASK:
Example: Some kind of kernel32 call?
Example: Process Initialization

<a name="ntcorollaries"></a>
#### Corollaries
* Since the C stubs for NT system calls are provided by `ntdll.dll`, your
  application's C library does *not* include any syscall stubs! Furthermore,
  implementing your own stubs would be a terribly dangerous idea; as a
  closed-source OS, NT's native API, including its syscall IDs, is generally
  undocumented and consistently subject to change!
* Since the user-mode heap manager cannot be overridden on a process-global
  basis, there is a limit as to how far an application's efforts to use a
  custom allocator may reach. In the case of Gecko, our processes' use of
  `jemalloc` is limited to our own binaries. Any system or third-party DLLs
  used by our processes will continue to use NT's heap manager. This includes
  (without limitation):
    * `ntdll.dll` itself, including the dynamic linker;
    * Core Win32 personality DLLs (`kernel32.dll`, `advapi32.dll`, `user32.dll`,
      `gdi32.dll`) and their dependencies;
    * The C runtime library itself (its internal `malloc`s will go to the
      NT heap manager);
    * Any COM objects instantiated from DLLs that are not ours;
    * The COM runtime itself;
    * DirectX;
    * Higher-level libraries and APIs provided by Windows, including shell APIs,
      UI widgets, etc.;
    * Third-party libraries injected into our processes.

  After reading this list, hopefully you understand that, even with `jemalloc`,
  Gecko processes will still extensively use the NT heap manager, and this fact
  should not be ignored. Just like `jemalloc`, the NT heap manager provides
  management APIs (by way of the Win32 personality, of course) that may be used
  to do things like [validating the heap](https://docs.microsoft.com/en-us/windows/win32/api/heapapi/nf-heapapi-heapvalidate),
  [triggering freeing of unused pages](https://docs.microsoft.com/en-us/windows/win32/api/heapapi/nf-heapapi-heapsetinformation),
  as well as [walking the heap](https://docs.microsoft.com/en-us/windows/win32/api/heapapi/nf-heapapi-heapwalk)
  to determine the characteristics of its memory usage. In {%bug 1553296%} I
  added support for freeing unused pages, however Gecko does not really use the
  other APIs (hint, hint).

<a name="ntvm"></a>
### Virtual Memory Management
ASLR?
No oom killer

<a name="ntio"></a>
### I/O
Layered architecture
Overlapped I/O + IOCP + thread pool is the way to go, optimized for throughput

<a name="seh"></a>
### Exception Handling
* Fast crashing that skips the default exception handler
* EXCEPTION_IN_PAGE_ERROR

<a name="handles"></a>
## "Kernel Handles" vs Other Handles
* Which handles are kernel handles, which ones are not
* Kernel handles, kernel objects, references
* Pseudo-handles

<a name="hwnd"></a>
## Window Messaging

(Maybe) associating C++ objects with Win32 windows
Sent vs Posted Messages
Avoid parent-child relationships between HWNDs each owned by distinct threads

<a name="com"></a>
## COM

This section is not intended to make you a COM expert. In my experience, most
cross-platform developers encounter COM by needing to instantiate objects and
call methods on them. Sometimes developers need to implement an interface
to receive event callbacks. By limiting the content in this section to the
aforementioned scenario, you will hopefully understand the bare miniumum
needed to avoid performance and correctness problems when working with COM
objects.

If you're doing anything more COMplicated than this, I'd suggest consulting
with an expert! If you're a Mozilla developer and you need somebody to talk to,
a peer of the [`MSCOM` module](https://wiki.mozilla.org/Modules/Core#MSCOM)
would be an excellent choice! [*Are you a Mozilla developer who would like to
become a peer of this module? Please reach out to me!*]

* COM is more than just a reference-counted ABI
* "Real" COM, or "Fake COM?" eg DirectX
* Apartments
* Whether and when to `CoInitializeEx` (generally, never)
* Don't use `CoInitialize`
* Don't use `OleInitialize`
* Gecko: Outside of xul, use mscom::ProcessRuntime
* Local vs remote
* CoCreateInstance and `CLSCTX` - what's safe to use, perf implications
* Instantiating a COM object implicitly loads a DLL. Apartments are important.
  May need to pre-load the DLL off main thread to avoid I/O but still get
  the right apartment.
