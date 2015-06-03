---
title: "Why Ruby's Timeout is Broken"
layout: post
tags: [ruby, concurrency]
date: 2015-06-03 13:56:48 EDT
comments: true
share: true  
image:
  feature: russia-journal-narrower.png
---

From here: https://github.com/ruby-concurrency/concurrent-ruby/commit/ce0971d2a742699360a68e246b29631aad61bdf0#commitcomment-11215279

@jjb Great question. Thank you for asking. There was only a brief conversation between myself and @pitr-ch but it doesn't contain enough information to be generally useful. Basically, he asked asked about removing it and I responded "I can't remember why I added it in the first place, so go ahead." In the interim I remember why I added it so this is probably a good time to discuss it further.

**TL;DR** Ruby's `Timeout` module is [generally considered broken](http://www.mikeperham.com/2015/05/08/timeout-rubys-most-dangerous-api/) and many recommend never using it. Our implementation was an internal tool used for our own synchronization. We no longer need it internally so we deprecated it. We still have many other synchronization mechanisms available.

Ruby's standard library lacks many low-level synchronization and locking abstractions. In some of the earliest, most naive implementations of this library I used timeouts frequently. Because of the probelms with Ruby's timeout, I created my own. Over time we added many more low-level abstractions that provide finer-grained control. Our internal use of our timeout method slowly waned. With the common synchronization layer added in #273 and several subsequent updates, we no longer use our timeout method.

One of the main issues with Ruby's `Timeout` module is the underlying threading (each call spawns a new thread and, when necessary, uses the `#kill` method). Our implementation was more efficient because it ran on the global thread pool, but internally it's nothing but a `Future`. Any case where our timeout was used it could easily be replaced with `Future`. Additionally we have `Event`, `Semaphore`, `CountDownLatch`, `Synchronization::Object`, etc. All of these are potentially more efficient, depending on the use case.

I appreciate the simplicity of a `Concurrent.timeout` method and am not opposed to having one if the community finds it useful. If we decide to keep the method I definitely want to revisit the implementation. I don't believe the current implementation is very efficient given the better tools we now have available.

I should also note that out implementation could be considered "buggy" in that it doesn't cancel the task. The Ruby timeout method will attempt to brutally kill the task thread on timeout. This can leave resources in an inconsistent state. Our timeout simply left the task executing, which can lead to its own set of problems. To properly handle timeout we would need to find a way to cancel the running task (or at least *try* to cancel the running task). Both defining the behavior and implementing it may be difficult.

