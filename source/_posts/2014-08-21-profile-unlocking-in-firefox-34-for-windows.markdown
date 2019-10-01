---
layout: post
title: "Profile Unlocking in Firefox 34 for Windows"
date: 2014-08-21 10:00:00 -0600
comments: true
categories: [Mozilla, New Features, Shutdown]
---
Today's [Nightly 34](http://nightly.mozilla.org) build includes the work I did 
for {%bug 286355%}: a profile unlocker for our Windows users. This should be very 
helpful to those users whose workflow is interrupted by a Firefox instance that 
cannot start because a previous Firefox instance has not finished shutting down. 

Firefox 34 users running Windows Vista or newer will now be presented with this 
dialog box:

{% clkimg https://dblohm7.ca/images/profile-unlocker.png %}

Clicking "Close Firefox" will terminate that previous instance and proceed 
with starting your new Firefox instance.

Unfortunately this feature is not available to Windows XP users. To support this 
feature on Windows XP we would need to call undocumented API functions. I 
prefer to avoid calling undocumented APIs when writing production software due 
to the potential stability and compatibility issues that can arise from doing 
so.

While this feature adds some convenience to an otherwise annoying issue, please 
be assured that the Desktop Performance Team will continue to investigate and 
fix the root causes of long shutdowns so that a profile unlocker hopefully 
becomes unnecessary.
