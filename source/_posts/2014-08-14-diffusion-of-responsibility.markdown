---
layout: post
title: "Diffusion of Responsibility"
date: 2014-08-14 14:00:00 -0600
comments: true
categories: [Mozilla]
---
Something that I've been noticing on numerous social media and discussion forum 
sites is that whenever Firefox comes up, inevitably there are comments in those 
threads that steer toward Firefox performance. Given my role at Mozilla, these 
comments are of particular interest to me.

The reaction to roc's [recent blog post](http://robert.ocallahan.org/2014/08/choose-firefox-now-or-later-you-wont.html) 
has motivated me enough to respond to a specific subset of comments that 
exhibit the following pattern:

* They contain declarations that Firefox has serious performance and/or memory problems;
* They include a brief anecdote about jank/crashes/memory that the commenter has personally experienced;
* They link to other similar comments as evidence;
* They claim that Mozilla is in denial and refuses to find problems and fix them;
* They include nothing that is actionable by Mozilla.

To me the common theme in these comments is that their authors are experiencing 
problems but are not reporting them to Mozilla in an actionable way.

How Mozilla Finds Problems
--------------------------

Mozilla encourages our contributors to run prerelease versions of Firefox, 
especially [Nightly](http://nightly.mozilla.org) builds. This allows us to do 
some good old-fashioned dogfooding during the development of a Firefox release. 
We also have many tools that run as part of our continuous integration 
infrastructure to help find problems. Valgrind, Address Sanitizer, 
Leak Sanitizer, reference count tracking, deadlock detection, 
Talos performance tests, and xperf are some of the various tools that we apply 
to our builds. I do not claim that this list is exhaustive! :-)

We use numerous technologies to discover problems that occur while running on 
our users' computers. We have a crash reporter that (with the user's consent) 
reports data about the crash (interested parties may take a peek at our crash 
statistics [here](https://crash-stats.mozilla.com/home/products/Firefox).). 
We have Firefox Health Report and (with the users's consent) [Telemetry](http://telemetry.mozilla.org) 
that send us useful information for discovering problems.

If You See Something, Report It!
--------------------------------

