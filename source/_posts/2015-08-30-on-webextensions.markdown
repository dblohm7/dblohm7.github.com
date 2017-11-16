---
layout: post
title: "On WebExtensions"
date: 2015-08-30 02:00:00 -0600
comments: true
categories: [Mozilla, Extensions, Philosophizing]
---
There has been enough that has been said over the past week about [WebExtensions](https://blog.mozilla.org/addons/2015/08/21/the-future-of-developing-firefox-add-ons/) 
that I wasn't sure if I wanted to write this post. As usual, I can't seem to 
help myself. Note the usual disclaimer that this is my personal opinion. Further 
note that I have no involvement with WebExtensions at this time, so I write this 
from the point of view of an observer.

API? What API?
--------------

I shall begin with the proposition that the legacy, non-jetpack 
environment for addons is not an API. As ridiculous as some readers might 
consider this to be, please humour me for a moment.

Let us go back to the acronym, "API." **A**pplication **P**rogramming **I**nterface. 
While the usage of the term "API" seems to have expanded over the years to encompass 
just about any type of interface whatsoever, I'd like to explore the first letter of that 
acronym: *Application*.

An *Application* Programming Interface is a specific type of interface that is 
exposed for the purposes of building applications. It typically provides a 
formal abstraction layer that isolates applications from the implementation 
details behind the lower tier(s) in the software stack. In the case of web 
browsers, I suggest that there are two distinct types of applications: 
web content, and extensions.

There is obviously a very well defined API for web content. On the other hand, 
I would argue that Gecko's legacy addon environment is not an API at all! From 
the point of view of an extension, there is no abstraction, limited formality, 
and not necessarily an intention to be used by applications.

An extension is imported into Firefox with full privileges and can access whatever 
it wants. Does it have access to interfaces? Yes, but are those interfaces intended 
for *applications*? Some are, but many are not. The environment that Gecko
currently provides for legacy addons is analagous to an operating system running 
every single application in kernel mode. Is that powerful? Absolutely! Is that 
the best thing to do for maintainability and robustness? Absolutely not!

Somewhere a line needs to be drawn to demarcate this abstraction layer and
improve Gecko developers' ability to make improvements under the hood. Last
week's announcement was an invitation to addon developers to help shape that
future. Please participate and please do so constructively!

WebExtensions are not Chrome Extensions
---------------------------------------

When I first heard rumors about WebExtensions in Whistler, my source made it 
very clear to me that the WebExtensions initiative is not about making Chrome
extensions run in Firefox. In fact, I am quite disappointed with some of the 
press coverage that seems to completely miss this point.

Yes, WebExtensions will be implementing some APIs to be *source compatible* 
with Chrome. That makes it easier to port a Chrome extension, but porting will 
still be necessary. I like the Venn Diagram concept that the [WebExtensions FAQ](https://wiki.mozilla.org/WebExtensions/FAQ) 
uses: Some Chrome APIs will not be available in WebExtensions. On the other hand,
WebExtensions will be providing APIs above and beyond the Chrome API set that 
will maintain Firefox's legacy of extensibility.

Please try not to think of this project as Mozilla taking functionality away. 
In general I think it is safe to think of this as an opportunity to move that 
same functionality to a mechanism that is more formal and abstract.
