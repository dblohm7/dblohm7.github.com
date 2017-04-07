---
layout: post
title: "Asynchronous Plugin Initialization: Requiem"
date: 2017-04-07 15:00:00 -0600
comments: true
categories: [async, mozilla, plugins]
---
My colleague bsmedberg is going to be removing asynchronous plugin 
initialization in {%bug 1352575%}. Sadly the feature never became solid enough 
to remain enabled on release, so we cut our losses and cancelled the project 
early in 2016. Now that code is just a bunch of dead weight. With the 
deprecation of non-Flash NPAPI plugins in Firefox 52, our developers are now 
working on simplifying the remaining NPAPI code as much as possible.

Obviously the removal of that code does not prevent me from discussing some of 
the more interesting facets of that work.

Today I am going to talk about how async plugin init worked when web content 
attempted to access a property on a plugin's scriptable object, when that 
plugin had not yet completed its asynchronous initialization.

As [described on MDN](https://developer.mozilla.org/en-US/docs/Plugins/Guide/Scripting_plugins), 
the DOM queries a plugin for scriptability by calling `NPP_GetValue` with the 
`NPPVpluginScriptableNPObject` constant. With async plugin init, we did not 
return the true NPAPI scriptable object back to the DOM. Instead we returned 
a surrogate object. This meant that we did not need to synchronously wait for 
the plugin to initialize before returning a result back to the DOM.

If the DOM subsequently called into that surrogate object, the surrogate would 
be forced to synchronize with the plugin. There was a limit on how much fakery 
the async surrogate could do once the DOM needed a definitive answer -- after 
all, the NPAPI itself is entirely synchronous. While you may question whether 
the asynchronous surrogate actually bought us any responsiveness, performance 
profiles and measurements that I took at the time did indeed demonstrate that 
the asynchronous surrogate did buy us enough additional concurrency to make it 
worthwhile. A good number of plugin instantiations were able to complete in 
time before the DOM had made a single invocation on the surrogate.

Once the surrogate object had synchronized with the plugin, it would then mostly 
act as a pass-through to the plugin's real NPAPI scriptable object, with one 
notable exception: property accesses.

The reason for this is not necessarily obvious, so allow me to elaborate:

The DOM usually sets up a scriptable object as follows:

<pre><samp>
this.__proto__.__proto__.__proto__
</samp></pre>
* Where `this` is the WebIDL object (ie, content's `<embed>` element);
* Whose prototype is the NPAPI scriptable object;
* Whose prototype is the shared WebIDL prototype;
* Whose prototype is `Object.prototype`.

NPAPI is reentrant (some might say *insanely* reentrant). It is possible (and 
indeed common) for a plugin to set properties on the WebIDL object from within 
the plugin's `NPP_New`.

Suppose that the DOM tries to access a property on the plugin's WebIDL object
that is normally set by the plugin's `NPP_New`. In the asynchronous case, the 
plugin's initialization might still be in progress, so that property might not 
yet exist.

In the case where the property does not yet exist on the WebIDL object, JavaScript 
fails to retrieve an "own" property. It then moves on to the first prototype 
and attempts to resolve the property on that. As outlined above, this prototype 
would actually be the async surrogate. The async surrogate would then be in a 
situation where it must absolutely produce a definitive result, so this would 
trigger synchronization with the plugin. At this point the plugin would be 
guaranteed to have finished initializing.

Now we have a problem: JS was already examining the NPAPI scriptable object when 
it blocked to synchronize with the plugin. Meanwhile, the plugin went ahead and 
set properties (including the one that we're interested in) on the WebIDL object. 
By the time that JS execution resumes, it would already be looking too far up the 
prototype chain to see those new properties!

The surrogate needed to be aware of this when it synchronized with the plugin 
during a property access. If the plugin had already completed its initialization 
(thus rendering synchronization unnecessary), the surrogate would simply pass the 
property access on to the real NPAPI scriptable object. On the other hand, if a 
synchronization was performed, the surrogate would first retry the WebIDL object 
by querying for the WebIDL object's "own" properties, and return the own property
if it now existed. If no own property existed on the WebIDL object, then the 
surrogate would revert to its "pass through all the things" behaviour.

If I hadn't made the asynchronous surrogate scriptable object do that, we would 
have ended up with a strange situation where the DOM's initial property access 
on an embed could fail non-deterministically during page load.

That's enough chatter for today. I enjoy blogging about my crazy hacks that make 
the impossible, umm... possible, so maybe I'll write some more of these in the 
future.
