---
layout: post
title: "Asynchronous Plugin Initialization: An Introduction"
date: 2014-06-17 02:30:00 -0600
comments: true
categories: [Mozilla, Plugins, Async]
---
I have spent a lot of time this quarter working on {%bug 998863%}, "Asynchronous 
Initialization of Out-of-process Plugins." While the bug summary is fairly self 
explanatory, I would like to provide some more details about why I am doing this 
and what kind of work it entails. I would also like to wrap up the post with an 
early demonstration of this feature and present some profiles to illustrate the 
potential performance improvement.

Rationale
---------

The reason that I am undertaking this project is because NPAPI plugin startup 
is our most frequent cause of jank. In fact, at the time of this writing, our 
[Chrome Hangs telemetry](http://telemetry.mozilla.org/chromehangs/) is showing 
that 4 out of our top 10 most frequent offending call stacks are related to 
plugin initialization and instantiation. Furthermore, creating the 
plugin-container.exe child process is the #1 most frequent chrome hang offender 
(Note that our Chrome Hang telemetry consists entirely of Windows builds, where
process creation is quite expensive).

A High-level Breakdown of NPAPI Initialization and Instantiation
----------------------------------------------------------------

The typical steps involved can be broken down as follows:

1. Launch the `plugin-container` process;
2. Call `NP_Initialize` to load the plugin;
3. Create instances by calling `NPP_New`;
4. Call `NPP_NewStream` for instances that load stream data;
5. If an instance is scriptable, call `NPP_GetValue` to obtain information 
about the plugin's scriptable object.

The patch that I am working on modifies steps 1 through 4 to run asynchronously.
Step 5 is a special case -- we asynchronously return a proxy object, but if a 
synchronous JS method is called on that object, we must wait for the plugin to 
initialize (if it has not yet done so). My hope is that if we have to call a 
synchronous JS method on the proxy object, plugin initialization will be far 
enough along that the wait will be minimal.

A Brief Demonstration
---------------------

The following video compares two locally-built Nightlies that are identical 
except for the asynchronous initialization patch. After loading the browser 
with a page containing several embedded Flash objects, we can profile and 
observe the effects of this patch.

<iframe width="420" height="315" src="//www.youtube-nocookie.com/embed/HZ8Z2Drv8uI?rel-0" frameborder="0" allowfullscreen></iframe>

Here are links to some profiles:

[Synchronous Plugin Initialization](http://people.mozilla.org/~bgirard/cleopatra/#report=a5a96119742fa75b64ab7d12566eede68468ef3c)

[Asynchronous Plugin Initialization](http://people.mozilla.org/~bgirard/cleopatra/#report=282e372d3357316307c182607f26c00f4f41011e)

Disclaimer
----------

This patch requires some further work on scripting and stabilization. The 
information in this post is subject to change. :-)

