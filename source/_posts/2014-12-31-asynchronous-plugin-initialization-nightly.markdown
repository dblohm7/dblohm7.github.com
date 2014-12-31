---
layout: post
title: "Asynchronous Plugin Initialization: Nightly"
date: 2014-12-31 12:00:00 -0700
comments: true
categories: [Mozilla, Plugins, Async]
---
As of today's [Nightly](http://nightly.mozilla.org), Asyncrhonous Plugin 
Initialization is available for testing. It is deactivated by default, so in 
order to try it out you will need to navigate to `about:config` and toggle the 
`dom.ipc.plugins.asyncInit` preference to `true`.

If you experience any problems, please [file a bug](https://bugzilla.mozilla.org/enter_bug.cgi?product=Core&component=Plug-ins&blocked=1116806) that blocks {%bug 1116806%}.

Happy New Year!
