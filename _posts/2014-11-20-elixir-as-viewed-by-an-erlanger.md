---
layout: post
title: "Elixir As Viewed By An Erlanger"
modified: 2014-10-20 23:00:00 -0400
tags: [erlang, elixir]
comments: true
share: true  
image:
  feature: russia-journal-narrower.png
---

When people discover I work in a shop whose primary languages are both Erlang and Ruby, something inevitable happens: I get asked about Elixir. People assume that my love of both Ruby and Erlang automatically equates to love of Elixir, and they are surprised to learn this isn't the case. Elixir is a wonderful language with a very passionate community. I have nothing *against* Elixir. I simply haven't found a significant reason to move to Elixir *from* Erlang.

Anything that grows the Erlang community is good for Erlang. Elixir has attracted many new developers and swelled attendance at Erlang conferences. Elixir is making the Erlang community a more vibrant and active place. This is undeniably good and makes me a fan of Elixir. But this isn't a reason for me to move from Erlang to Elixir. Despite its relative immaturity, Elixir provides a very powerful and compelling feature set. What it doesn't do, however, is provide a feature set that isn't fully shared by Erlang.

One common misconception of Erlang is that the language itself comprises the sum of its features. For many languages there is no distinction between the language, its runtime, and its standard library. In this area Erlang is critically different from other languages. The Erlang language itself is intentionally terse and minimal. The real power comes from the combination of the language, compiled Beam bytecode, the virtual machine, and the OTP library.

When people talk about Erlang they generally discuss its excellence in building scalable, highly available, redundant, fault-tolerant systems. As well they should. This is exactly the problem Erlang was designed to solve. What is often misunderstood is that virtually all these capabilities have nothing to do with the Erlang language itself. Most of these capabilities are provided by the Erlang VM, the compiled Beam bytecode, and the OTP library. Although these systems were all designed together and all evolved together, they are separate things. A fact which Elixir smartly takes advantage of. The beauty of Elixir is that it fully embraces the entire Erlang ecosystem. Elixir compiles to Beam bytecode, runs in the Erlang VM, and is fully compatible with the OTP library. This begs the question: What does Elixir offer to a programmer already proficient in Erlang?

The syntax and semantics of Elixir are very modern and heavily influenced by Ruby, making the language very accessible to a wide range of programmers. This is by design and has been a critical factor in the growth of and excitement around Elixir. Erlang, on the other hand, is a pure functional language with origins in Prolog. Compared to many mainstream languages it is very esoteric and the learning curve is steep. For many Elixir is more approachable and easier to learn. This is the true strength of Elixir. To the seasoned Erlanger, however, it isn't nearly as compelling. The mountain has already been climbed.

So as I said earlier, my coworkers and I are very excited that Elixir is growing the Erlang community. We have great respect for Elixir's creators and contributors. They have done great work which should be lauded. But we like Erlang. We are productive with Erlang and it makes us happy. I definitely understand why programmers new to Erlang choose to start with Elixir. But for me, we're happy to stay where we are--leveraging the maturity and stability of Erlang to build cool applications.
