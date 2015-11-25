---
title: "Testing Concurrent Code"
layout: post
tags: [concurrency ruby testing]
date: 2015-11-25 00:00:01 EDT
comments: true
share: true
image:
  feature: russia-journal-narrower.png
---

Every now and then the question of testing concurrent code pops up. This isn't surprising. Testing is hard. Concurrency is hard. It stands to reason that testing concurrent code must be hard, too. And this leads to a lot of confusion. Worse, it leads to a lot of really bad tests. This doesn't have to be the case. In reality, testing concurrent code isn't that hard. You just need to remember one simple rule:

> Don't test concurrent code.

## TL;DR

OK, that probably isn't very helpful. It's not quite that simple. But it's very close. Testing concurrent code is really no different than testing serial code. Code that is difficult to test is a code smell. It generally indicates design problems. Similarly, concurrent code that is well written is also easy to test. Writing good concurrent code comes down to three simple rules:

1. Separate business logic from concurrency.
1. Use reliable, well-tested concurrency abstractions.
1. Minimize the intersection of business logic and concurrency.

## Are You Down With SRP?

Before we talk about concurrency, let's get back to basics. One of the core tenets of object-oriented programming is that each class should have one and only one responsibility. We call this the Single Responsibility Principle and Wikipedia [defines it](https://en.wikipedia.org/wiki/Single_responsibility_principle) as "every class should have responsibility over a single part of the functionality provided by the software, and that responsibility should be entirely encapsulated by the class. All its services should be narrowly aligned with that responsibility."

When writing concurrent code the single responsibility principle still applies. The trick is to remember that:

> Concurrency is its own responsibility.

Once we accept this simple and foundational idea, the three aforementioned rules begin to make a lot more sense. Let's revisit each one individually. But first, let's look at some code.

## Putting It All Together

The following code sample is an excerpt from the [presentation](https://github.com/jdantonio/Everything-You-Know-About-the-GIL-is-Wrong-RubyConf-2015) I gave at RubyConf last week. Although it's Ruby code, the ideas within are applicable to every programming language.

{% highlight ruby %}
#!/usr/bin/env ruby

require 'concurrent'
require 'open-uri' # for open(uri)

SYMBOLS = ['MA', 'PCLN', 'ADP', 'V', 'TSS', 'FISV', 'EBAY', 'PAYX', 'WDC', 'SYMC',
           'AAPL', 'AMZN', 'KLAC', 'FNFV', 'XLNX', 'MSI', 'ADI', 'VRSN', 'CA', 'YHOO']
YEAR = 2014

def get_year_end_closing(symbol, year)
  uri = "http://ichart.finance.yahoo.com/table.csv?s=#{symbol}&a=01&b=04&c=#{year}&d=01&e=14&f=#{year+1}&g=d&ignore=.csv "
  data = open(uri) {|f| f.collect{|line| line.strip } }
  data[1].split(',')[4].to_f
end

futures = SYMBOLS.collect do |symbol|
  Concurrent::Future.execute { get_year_end_closing(symbol, year) }
end

puts futures.collect { |future| future.value }
{% endhighlight %}

I've been using variations of this example for several years. The code itself is largely irrelevant. The structure is what's important. Before we get to that, let's go over the code.

This script uses the [Yahoo! Finance](http://finance.yahoo.com/) API to retrieve historical stock data. The `get_year_end_closing` function takes a stock ticker symbol and a year. It uses these two values to craft the necessary URL. It then uses the `open-uri` functions from Ruby's standard library to retrieve the historical data. Finally, it parses the returned data to retrieve the year end closing for the ticker symbol.

After the function definition we get to the concurrent part of the program. Early in the program we define the `SYMBOLS` constant as an array of 20 stock ticker symbols. Towards the end of the program we iterate over this array and use `Concurrent::Future` from [concurrent-ruby](https://github.com/ruby-concurrency/concurrent-ruby) to retrieve the stock market data for each ticker symbol. The `#execute` method of `Concurrent::Future` causes the given block to be post to the global thread pool and run in the background. The `#collect` method creates an array containing the individual `Concurrent::Future` objects and stores them in the `futures` variable.

The final line of the program then iterates over the collected `Concurrent::Future` objects and collects the results into an array which is then output to the console.

Now that we have some code, let's get back to the purpose of this blog post: testing.

### Separate business logic from concurrency

All of the business logic in the sample program is contained within the `get_year_end_closing` function. All of it. It has a single responsibility, just like good code should. More importantly, there is absolutely *no* concurrency in this code. None. It's just a simple function. Testing it is pretty straight-forward. There is no magic here, and no surprises. Just plain old Ruby code.

***When business logic is distinctly separate from concurrency it is easy to test.***

### Use reliable, well-tested concurrency abstractions

When we finally get to the concurrency we use `Concurrent::Future`. It, too, has a single responsibility. It is a dedicated concurrency abstraction. It's part of the concurrent-ruby library and it is [highly tested](https://travis-ci.org/ruby-concurrency/concurrent-ruby). At the time of this writing there are over 2300 tests in the test suite and it runs against 12 different Ruby runtimes.

Notice that we don't roll our own concurrency here?<sup>1</sup> Concurrent code is hard. Testing it is even harder (which is kind of the whole point of this blog post). When you use a mature, reliable library you eliminate much of the risk. As with any good dependency, you don't have to test it yourself. You know that it does what it promises to do.

***Don't test your dependencies. If you can't trust a dependency, find a new one.***

### Minimize the intersection of business logic and concurrency

When our program finally gets to the point where it needs to behave concurrently, it does so with a single function call. The block passed to our `Concurrent::Future` can be as simple or as complex as we want it to be. The big mistake programmers new to concurrency make is that they put *way* too much code inside their concurrent calls. The example above limits it to one. One single function call. That's it. No muss, no fuss. Just one call. By keeping the intersection of our business logic so narrow we greatly reduce our testing burden. We no longer need to test concurrent logic, we only need to test that our logic is triggered concurrently.

In her awesome book [Practical Object-Oriented Design in Ruby](http://www.poodr.com/), Sandi Metz tells us exactly what we need to do here, although she may not have realized it at the time. Nothing in Sandi's book discusses concurrency, but all of her guidance still applies. Chapter 9, "Designing CostEffective Tests," has a section called "Testing Outgoing Messages." It it she tells us "Sometimes, however, it *does* matter that a message is sent; other parts of your application depend on something that happens as a result. In this case the object under test is responsible for sending the message and your tests must prove it does so."

Put more simply, if object `A` calls method `foo` on object `B` our tests for object `A` should not re-test the `foo` method, our tests simply need to ensure that `A` does, indeed, call `foo` on `B`.

Which brings us to the point of this whole blog post. In our sample code above we don't need to test the `get_year_end_closing` function *and* our concurrency at the same time. We simply need to test that the `get_year_end_closing` function is called the right number of times and with the correct number of parameters. That's it. There is nothing more to it.

***When business logic and concurrency are separate, we only need one integration test for the intersection of the two.***

## Why All The Fuss?

The trouble that most programmers new to concurrency get themselves into is that they deeply couple their business logic with the concurrency code. When that happens the tests are extremely hard to get right. They involve complex timing and synchronization. The resulting tests become highly unreliable and prone to intermittent false negatives. Imagine that the sample code above didn't have the `get_year_end_closing` function and instead dropped all that code directly into the `Concurrent::Future`. How would we test that? How would we ensure that our tests are reliable? The answer to both questions is that we wouldn't. It would be an exercise in futility.

Don't make your life any more difficult than it needs to be. Whenever writing concurrent code follow the three simple rules above and keep your business logic separated from the concurrency.

## Finally

And please, whatever you do, do *not* mock/stub concurrency.

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">&quot;How do I use JUnit to test multi-threaded programs?&quot; &quot;You should mock the other threads.&quot; No, no, a thousand times no.</p>&mdash; Charles Nutter (@headius) <a href="https://twitter.com/headius/status/669177799177998337">November 24, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<sup>[1]</sup> Technically speaking *I* rolled my own concurrency code because I created concurrent-ruby. But you get my point. :-)
