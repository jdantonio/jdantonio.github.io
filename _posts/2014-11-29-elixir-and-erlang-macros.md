---
layout: post
title: "Erlang, Elixir, and Hygenic Macros"
modified: 2014-10-29 11:20:00 -0500
tags: [erlang, elixir]
comments: true
share: true  
image:
  feature: russia-journal-narrower.png
---

Several have noted in the comments [to my previous post](/elixir-as-viewed-by-an-erlanger/)
that Elixir has hygenic macros and Erlang does not. This is true, so the issue warrants further discussion.

Erlang's support for metaprogramming is much more limited than Elixir's. Erlang supports metaprogramming
in the "dynamic code generation at runtime" sense through high order functions, anyonymous functions,
and [hot code replacement](http://www.erlang.org/doc/reference_manual/code_loading.html). In this context,
[Joe Armstrong's Universal Server](http://joearms.github.io/2013/11/21/My-favorite-erlang-program.html)
is--hands down--one of the most brilliant examples of metaprogramming I've ever encountered.

What Erlang lacks, and Elixir provides, is metaprogramming in the "code as data, extend the language" sense.
Elixir's [hygenic macros](http://elixir-lang.org/getting_started/meta/2.html) provide this functionality.
For any programmer who desires the ability to extend the language via hygenic macros, Elixir is the obvious
choise. Erlang provides nothing similar to Elixir's macros<sup>[1]</sup> and there isn't any indication it
ever will. But it's very important to note the caveat in the previous sentence: *For any programmer who
desires...*

Many programmers, myself included, do not feel that hygenic macros are a necessary language feature.
Poor use of macros is often considered an anti-pattern, much the way excessive use of metaprogramming
in Ruby is often highly problematic. Hygenic marcos have existed in Lisp for decades yet most
modern programming languages eschew them. Rich Hickey famously excluded macros from Clojure at the outset
and fought against their inclusion for years. Macros were only added to Clojure as a tool to implement
Clojure *in* Clojure (many language constructs could not be implemented as simple functions). Many Clojure
programmers still consider macros a special tool not for use in solving general programming problems.
Similarly, many consider an excessive use of macros by experienced Lisp programmers to be one of the
langauge's biggest problems. Lisp programs which make heavy use of macros often read as though written
in a completely different language!

I can appreciate that in certain special situations--such as *implementing* a language which targets an
existing virtual machine--hygenic macros can be a very powerful tool. But for general programming problems
they are often overkill and lead to hard to understand and hard to maintain code. Since I, personally, am
not a fan of hygenic macros as a general programming tool, the lack of hygenic macros in Erlang is not
an issue for me. Thus, their inclusion in Elixir does not an enticement, either.

1. Note that Erlang's [macros](http://erlang.org/doc/reference_manual/macros.html) are an entirely different
   and far less functional construct.
