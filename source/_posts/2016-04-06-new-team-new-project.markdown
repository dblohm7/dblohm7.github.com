---
layout: post
title: "New Team, New Project"
date: 2016-04-06 21:00:00 -0600
comments: true
categories: [Mozilla, Win32, COM, a11y]
---
In February of this year I switched teams: After 3+ years on Mozilla's 
Performance Team, and after having the word "performance" in my job description
in some form or another for several years prior to that, I decided that it was
time for me to move on to new challenges. Fortunately the Platform org was
willing to have me set up shop under the (e10s|sandboxing|platform integration)
umbrella.

I am pretty excited about this new role!

My first project is to sort out the accessibility situation under Windows e10s.
This started back at Mozlando last December. A number of engineers from across 
the Platform org, plus me, got together to brainstorm. Not too long after we had
all returned home, I ended up making a suggestion on an email thread that has
evolved into the core concept that I am currently attempting. As is typical at
Mozilla, no deed goes unpunished, so I have been asked to flesh out my ideas.
An overview of this plan is available on the [wiki](https://wiki.mozilla.org/Electrolysis/Accessibility/Windows).

My hope is that I'll be able to deliver a working, "version 0.9" type of demo 
in time for our London all-hands at the end of Q2. Hopefully we will be able to
deliver on that!

Some Additional Notes
---------------------

I am using this section of the blog post to make some additional notes. I don't
feel that these ideas are strong enough to commit to a wiki yet, but I do want 
them to be publicly available.

Once concern that our colleagues at NVAccess have identified is that the 
current COM interfaces are too chatty; this is a major reason why screen 
readers frequently inject libraries into the Firefox address space. If we serve
our content a11y objects as remote COM objects, there is concern that performance
would suffer. This concern is not due to latency, but rather due to frequency
of calls; one function call does not provide sufficient information to the a11y
client. As a result, multiple round trips are required to fetch all of the 
information that is required for a particular DOM node.

My gut feeling about this is that this is probably a legitimate concern, however
we cannot make good decisions without quantifying the performance. My plan going
forward is to proceed with a na&iuml;ve implementation of COM remoting to start,
followed by work on reducing round trips as necessary.

## Smart Proxies

One idea that was discussed is the idea of the content process speculatively 
sending information to the chrome process that might be needed in the future.
For example, if we have an `IAccessible`, we can expect that multiple properties
will be queried off that interface. A smart proxy could ship that data across
the RPC channel during marshaling so that querying that additional information
does not require additional round trips.

COM makes this possible using "handler marshaling." I have dug up some 
information about how to do this and am posting it here for posterity:

[House of COM, May 1999 *Microsoft Systems Journal*](https://www.microsoft.com/msj/0599/com/com0599.aspx);<br/>
[Implementing and Activating a Handler with Extra Data Supplied by Server](https://msdn.microsoft.com/en-us/library/windows/desktop/ms683786.aspx) on MSDN;<br/>
Wicked Code, August 2000 *MSDN Magazine*. This is not available on the MSDN Magazine website but I have an archived copy on CD-ROM.<br/>

