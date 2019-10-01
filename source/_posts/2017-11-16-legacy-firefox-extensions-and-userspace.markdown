---
layout: post
title: "Legacy Firefox Extensions and \"Userspace\""
date: 2017-11-16 13:30:00 -0700
comments: true
categories: [Mozilla, Extensions, Philosophizing]
---
This week's release of Firefox Quantum has prompted all kinds of feedback, both 
positive and negative. That is not surprising to anybody -- any software that 
has a large number of users is going to be a topic for discussion, especially 
when the release in question is undoubtedly a watershed.

While I have [previously](https://dblohm7.ca/blog/2015/08/30/on-webextensions/) 
blogged about the transition to WebExtensions, now that we have actually passed 
through the cutoff for legacy extensions, I have decided to add some new 
commentary on the subject.

One analogy that has been used in the discussion of the extension ecosystem is 
that of kernelspace and userspace. The crux of the analogy is that Gecko is 
equivalent to an operating system kernel, and thus extensions are the user-mode 
programs that run atop that kernel. The argument then follows that Mozilla's 
deprecation and removal of legacy extension capabilities is akin to "breaking" 
userspace. [*Some people who say this are using the same tone as Linus does 
whenever he eviscerates Linux developers who break userspace, which is neither 
productive nor welcomed by anyone, but I digress.*] Unfortunately, that analogy 
simply does not map to the legacy extension model.

Legacy Extensions as Kernel Modules
-----------------------------------

The most significant problem with the userspace analogy is that legacy extensions 
effectively meld with Gecko and become part of Gecko itself. If we accept the 
premise that Gecko is like a monolithic OS kernel, then we must also accept that
the analogical equivalent of loading arbitrary code into that kernel, is the 
kernel module. Such components are loaded into the kernel and effectively become 
part of it. Their code runs with full privileges. They break whenever 
significant changes are made to the kernel itself.

Sound familiar?

Legacy extensions were akin to kernel modules. When there is no abstraction, 
there can be no such thing as userspace. This is precisely the problem that 
WebExtensions solves!

Building Out a Legacy API
-------------------------

Maybe somebody out there is thinking, "well what if you took all the APIs that 
legacy extensions used, turned that into a 'userspace,' and then just left that 
part alone?"

Which APIs? Where do we draw the line? Do we check the code coverage for every 
legacy addon in AMO and use that to determine what to include?

Remember, there was no abstraction; installed legacy addons are fused to Gecko. 
If we pledge not to touch anything that legacy addons might touch, then we 
cannot touch anything at all.

Where do we go from here? Freeze an old version of Gecko and host an entire copy 
of it inside web content? Compile it to WebAssembly? [*Oh God, what have I done?*]

If *that's* not a maintenance burden, I don't know what is!

A Kernel Analogy for WebExtensions
----------------------------------

Another problem with the legacy-extensions-as-userspace analogy is that it leaves 
awkward room for web content, whose API is abstract and well-defined. I do not 
think that it is appropriate to consider web content to be equivalent to a 
sandboxed application, as sandboxed applications use the same (albeit restricted) 
API as normal applications. I would suggest that the presence of WebExtensions
gives us a better kernel analogy:

* Gecko is the kernel;
* WebExtensions are privileged user applications;
* Web content runs as unprivileged user applications.

In Conclusion
-------------

Declaring that legacy extensions are userspace does not make them so. The way that 
the technology actually worked defies the abstract model that the analogy 
attempts to impose upon it. On the other hand, we can use the failure of that 
analogy to explain why WebExtensions are important and construct an extension 
ecosystem that *does* fit with that analogy.


