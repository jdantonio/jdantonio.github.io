---
layout: post
title: "The Keywords 'class' and 'new' Are Overrated"
modified: 2014-07-14 10:00:00 -0400
tags: [oop, fp, ruby]
comments: true
share: true  
image:
  feature: russia-journal-narrower.png
---
*I originally post this to my previous blog about 2 or 3 years ago. I figure if I'm going to let another blog go fallow I may as well start with this post. --Jerry*

A coworker of mine recently noticed that I tend to write function libraries in Ruby more often than most. I don't eschew object orientation. To the contrary, several projects I've worked on recently use very traditional, pattern-based object designs. I just have a tendency to write modules with no state and nothing but module-level ("static" in Java and C++) functions. So here's the story…

Many years ago I was a hardcore OO zealot, quoting Gang of Four like it was gospel. That changed when I took a job on a small C++ team writing high-performance, highly concurrent code. Even though we were using C++ the codebase was entirely in an ANSI C style: structs, function libraries, and crazy pointer manipulation.* None of my coworkers or our predecessors had written a single class definition. It was a huge change for me. I had a very difficult transition. I used OO when I could (libraries for logging, threads, messaging, some other stuff) but a lot of my time necessarily required working with the old-school code. What I eventually learned is that there's nothing wrong with that style of code. In some cases it is actually better. That shouldn't have surprised me. The operating systems and language compilers we use every day are mostly ANSI C. Somehow in our profession's transition to OO we've lost sight of that.

The truth is, sometimes a simple function library is all you need. They often perform better than objects and are frequently easier to reuse because they aren't coupled with state. They are also very easy to convert into classes: just add a constructor and some data members. The object methods simply call the class methods, passing the necessary data members as parameters and leaving the class methods intact. It's rarely as easy to convert a class into a function library because decoupling state can be difficult.

I guess if I had to put this approach into words I'd call it "add state when it's advantageous to." Don't actively avoid objects, but don't assume everything needs to be wrapped in a class, either.

I've recently noticed a trend in Ruby which clearly illustrates what I'm talking about. I've seen this often enough I consider it an anti-pattern. A Rails developer recently post a code sample and solicited feedback from the community. Putting aside the larger discussion regarding his design, there are two lines of code I think are needlessly stateful:

{% highlight ruby %}
PostToTwitter.new(@user, @comment).post
PostToFacebook.new(@user, @comment).action(:comment)
{% endhighlight %}

In both cases he creates objects then immediately discards them. This causes two needless performance penalties: one performance hit when the objects are created and another when they are passed to the garbage collector.[2] Both cases have a method dependency chain. The `#post` and `#action` methods are dependent on the constructor. Both methods require data that isn't passed directly through the argument list, they depend on data passed to the constructor. If the constructor is called incorrectly then `#post` and `#action` will fail. Since there is no `begin`/`rescue` block around these calls we can assume he isn't validating the constructor inputs. This means he has to validate the constructor inputs in the `#post` and `#action` methods. So now we have the second method in the chain validating the parameters of the first method. That's a very high degree of coupling and makes the class very brittle--a change to the constructor could easily break other methods. Why not write the code this way:

{% highlight ruby %}
PostToTwitter.post(@user, @comment)
PostToFacebook.comment(@user, @comment)
{% endhighlight %}

The stateless code has several advantages over the stateful version:

* It's faster: no performance hit for creating and garbage collecting objects
* It does not have a dependency chain between methods: there is only one method in each case
* The stateless methods are more cohesive: all the data they require is passed as parameters
* The stateless code is easier to test: you don't have to setup the objects before calling the methods under test
* Refactoring to a stateful class is trivial and won't effect existing code that uses the stateless methods

I can't think of a single reason why the stateless versions aren't superior in this example.

This is something I have really started to appreciate about Ruby recently. Unlike Java or C#, Ruby gives us plenty of options when we don't need classes. This is the central thesis of Steve Yegge's [Kingdom of Nouns](http://steve-yegge.blogspot.com/2006/03/execution-in-kingdom-of-nouns.html) blog post, and something I think many people completely miss: "I've really come around to what Perl folks were telling me 8 or 9 years ago: ‘Dude, not everything is an object.'"

This is why I've become so enamored with functional programming since I started studying the practice. Many of the precepts of functional programming are ideas/conclusions I've come to naturally over the years. John Carmack wrote a great blog post about this: "No matter what language you work in, programming in a functional style provides benefits. You should do it whenever it is convenient, and you should think hard about the decision when it isn't convenient."

Which is probably why Carmack is rich and famous and I'm not, because he said it better than I ever could.

---

*[1] You haven't felt real pain until you've had to debug triple pointer indirection across multiple threads. Trust me on this.*

*[2] The reason C++ does not have garbage collection is that no one has ever created a garbage collection algorithm that out-performs manual object deletion. As much as I love garbage collection in modern languages it's important for us to recognize the performance implications.*
