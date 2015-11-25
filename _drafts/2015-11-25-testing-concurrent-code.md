---
title: "Testing Concurrent Code"
layout: post
tags: [concurrency ruby testing]
date: 2015-11-25 12:00:00 EDT
comments: true
share: true
image:
  feature: russia-journal-narrower.png
---

Every now and then the question of testing concurrent code pops up. This isn't surprising. Testing is hard. Concurrency is hard. It stands to reason that testing concurrent code must be hard, too. And this leads to a lot of confusion. Worse, it leads to a lot of really bad tests. This doesn't have to be the case. In reality, testing concurrent code isn't that hard. You just need to remember one simple rule:

> Don't test concurrent code.

### TL;DR

OK, that probably isn't very helpful. It's not quite that simple. But it's very close. Testing concurrent code is really no different than testing serial code. Code that is difficult to test is a code smell. It generally indicates design problems. Similarly, concurrent code that is well written is also easy to test. Writing good concurrent code comes down to three simple rules:

1. Separate business logic from concurrency.
1. Use reliable, well-tested concurrency abstractions.
1. Minimize the intersection of business logic and concurrency.

### Single Responsibility Principle

### Finally

Please, whatever you do, do *not* mock/stub concurrency.

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">&quot;How do I use JUnit to test multi-threaded programs?&quot; &quot;You should mock the other threads.&quot; No, no, a thousand times no.</p>&mdash; Charles Nutter (@headius) <a href="https://twitter.com/headius/status/669177799177998337">November 24, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
