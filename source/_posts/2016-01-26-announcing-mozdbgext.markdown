---
layout: post
title: "Announcing mozdbgext"
date: 2016-01-26 12:45:00 -0700
comments: true
categories: [Mozilla, Debugging, Win32, mozdbgext]
---
A well-known problem at Mozilla is that, while most of our desktop users run
Windows, most of Mozilla's developers do not. There are a lot of problems that
result from that, but one of the most frustrating to me is that sometimes
those of us that actually use Windows for development find ourselves at a
disadvantage when it comes to tooling or other productivity enhancers.

In many ways this problem is also a Catch-22: People don't want to use Windows
for many reasons, but tooling is big part of the problem. OTOH, nobody is
motivated to improve the tooling situation if nobody is actually going to
use them.

A couple of weeks ago my frustrations with the situation boiled over when I
learned that our `Cpp` unit test suite could not log symbolicated call stacks,
resulting in my filing of {%bug 1238305%} and {%bug 1240605%}. Not only could we
not log those stacks, in many situations we could not view them in a debugger
either.

Due to the fact that PDB files consume a large amount of disk space, we don't
keep those when building from integration or try repositories. Unfortunately
they are be quite useful to have when there is a build failure. Most of our
integration builds, however, do include breakpad symbols. Developers may also
explicitly [request symbols](https://wiki.mozilla.org/ReleaseEngineering/TryServer#Getting_debug_symbols)
for their try builds.

A couple of years ago I had begun working on a WinDbg debugger extension that
was tailored to Mozilla development. It had mostly bitrotted over time, but I
decided to resurrect it for a new purpose: to help WinDbg<sup><a href="#fn1" id="r1">\*</a></sup>
grok breakpad.

Enter mozdbgext
---------------

[`mozdbgext`](https://github.com/dblohm7/mozdbgext) is the result. This extension
adds a few commands that makes Win32 debugging with breakpad a little bit easier.

The original plan was that I wanted `mozdbgext` to load breakpad symbols and then
insert them into the debugger's symbol table via the [`IDebugSymbols3::AddSyntheticSymbol`](https://msdn.microsoft.com/en-us/library/windows/hardware/ff537943%28v=vs.85%29.aspx)
API. Unfortunately the design of this API is not well equipped for bulk loading
of synthetic symbols: each individual symbol insertion causes the debugger to
re-sort its entire symbol table. Since `xul.dll`'s quantity of symbols is in the
six-figure range, using this API to load that quantity of symbols is
prohibitively expensive. I tweeted a Microsoft PM who works on Debugging Tools
for Windows, asking if there would be any improvements there, but it sounds like
this is not going to be happening any time soon.

My original plan would have been ideal from a UX perspective: the breakpad
symbols would look just like any other symbols in the debugger and could be
accessed and manipulated using the same set of commands. Since synthetic symbols
would not work for me in this case, I went for "Plan B:" Extension commands that
are separate from, but analagous to, regular WinDbg commands.

I plan to continuously improve the commands that are available. Until I have a
proper README checked in, I'll introduce the commands here.

### Loading the Extension

1. Use the `.load` command: `.load <path_to_mozdbgext_dll>`

### Loading the Breakpad Symbols

1. Extract the breakpad symbols into a directory.
2. In the debugger, enter `!bploadsyms <path_to_breakpad_symbol_directory>`
3. Note that this command will take some time to load all the relevant symbols.

### Working with Breakpad Symbols

**Note: You must have successfully run the `!bploadsyms` command first!**

As a general guide, I am attempting to name each breakpad command similarly to
the native WinDbg command, except that the command name is prefixed by `!bp`.

* Stack trace: `!bpk`
* Find nearest symbol to address: `!bpln <address>` where *address* is specified
as a hexadecimal value.

### Downloading windbgext

I have pre-built binaries ([32-bit](https://github.com/dblohm7/mozdbgext/blob/master/bin/32/mozdbgext.dll?raw=true), [64-bit](https://github.com/dblohm7/mozdbgext/blob/master/bin/64/mozdbgext.dll?raw=true))
(which obviously requires 32-bit WinDbg). I have not built a 64-bit binary yet,
but the code should be source compatible.

Note that there are several other commands that are "roughed-in" at this point
and do not work correctly yet. Please stick to the documented commands at this
time.

***

<sup><a href="#r1" id="fn1">\*</a></sup> When I write "WinDbg", I am really
referring to any debugger in the *Debugging Tools for Windows* package,
including `cdb`.
