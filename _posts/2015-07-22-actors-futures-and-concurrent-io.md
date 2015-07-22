---
layout: post
title: "Actors, Futures, and Concurrent I/O"
tags: [actors futures concurrency ruby concurrent-ruby]
date: 2015-07-22 12:00:00 EST
comments: true
share: true  
image:
  feature: russia-journal-narrower.png
---

Over on the [concurrent-ruby](https://github.com/ruby-concurrency/concurrent-ruby) GitHub someone recently asked me [this question](https://github.com/ruby-concurrency/concurrent-ruby/issues/379#issuecomment-123384743):

> When you want to run, say, 500 blocking operations at once (I/O Server), do you still need 500 actors?

My [answer](https://github.com/ruby-concurrency/concurrent-ruby/issues/379#issuecomment-123733023), in retrospect, seemed like it would make a good blog post so I decied to cross-post it here.

**TL;DR** Actors execute jobs serially so 500 actors would be necessary, but actors probably aren't the best solution to this particular problem.

**The Details**

Like all its high-level abstractions, our actors in `concurrent-ruby` run on one of the global thread pools. (You can also use dependency injection to provide a custom thread pool if you like.) Internally, however, each actor uses a class called `Concurrent::SerializedExecution` to ensure that each actor performs all its assigned tasks in the order they were received--one at a time. This behavior is *identical* to both actors in [Akka](http://akka.io/) and Erlang's [gen_server](http://www.erlang.org/doc/man/gen_server.html). A single actor does one thing at a time, it just does so concurrently with respect to everything else in the system.

If you want to run many I/O tasks simultaneously, `concurrent-ruby` has other high-level abstractions that may be better suited to the task. In this case `Concurrent::Future` is may be the better choice. Consider this code:

{% highlight ruby %}
require 'concurrent'

stock_symbols = [...] # provide a list of stock symbols here

futures = symbols.collect do |stock_symbol|
  Concurrent::Future.execute { MyFinanceApi.get_stock_price(stock_symbol) } # do the I/O operation here
end

stock_prices = futures.collect {|future| future.value } # iterate over all futures and get the values
{% endhighlight %}

The above code will run all the futures on the `GLOBAL_IO_EXECUTOR` which is a thread pool with an unbound size and unbound queue length. It will add as many threads as it needs (until the OS won't let it create any more--around 2000 on OS X, more on Linux). In the above example, all the I/O operations should run concurrently.

This highlights one of the biggest advantages of `concurrent-ruby` over other Ruby concurrency libraries. We are intentionally "unopinionated." We don't try to sell our users on the fallacy that there's a "one size fits all" concurrency solution. We provide a broad and deep toolkit that allows you to choose the best tool for the job.
