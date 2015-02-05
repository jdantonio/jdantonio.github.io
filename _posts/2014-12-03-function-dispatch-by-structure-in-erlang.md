---
layout: post
title: "Function Dispatch by Structure in Erlang"
modified: 2014-12-03 20:05:48 -0500
tags: [erlang, fp, 'functional programming', ruby]
comments: true
share: true  
image:
  feature: russia-journal-narrower.png
---

One of the errors many make when learning a new programming language is to impose sensibilities from other languages onto the
new language. "When I program in Java I do 'X', how do I do that in Ruby?" When the two languages are similar this isn't a
problem, it's learning by association. When the two languages are different, however, this incorrect thinking will generally
become an obstacle. Polymorphism in Erlang is often the victim of this cognitive error. Erlang is a dynamically typed,
strongly typed, functional programming language with pattern matching, guard clauses, and minimal collection abstractions.
Together these features create a very robust, powerful, and granular function dispatch mechanism. A mechanism which is
often misunderstood by newcomers to Erlang.

## Type-based Polymorphism

Many mainstream programming languages, especially statically and strongly typed object oriented languages like Java,
base polymorphism on an object's type. Take the following two Java classes for example:

{% highlight java linenos %}
class Hello {

  void speak() {
    System.out.println("Hello World!");
  }
}

class Goodbye extends Hello {

  void speak() {
    System.out.println("Goodbye!");
  }
}
{% endhighlight %}

These two classes have different types. One is of type `Hello` and the other is of type `Goodbye`. Because `Goodbye` is
subclass of `Hello`, a function call to the `speak()` can be dispatched to the appropriate implementation based on the
type of a given object:

{% highlight java linenos %}
Hello hello = new Hello();
Hello goodbye = new Goodbye();

hello.speak();    %=> Hello World!
goodbye.speak();  %=> Goodbye!
{% endhighlight %}

## Type-based Polymorphism in Erlang

Type-based polymorphism is possible in Erlang, although it is discouraged. Many consider it a code smell. The reason is
that Erlang--by design--has a limited number of data types and is also dynamically typed. Consider the following code:

{% highlight erlang linenos %}
speak(X) when is_float(X) ->
  io:fwrite("Hello World!~n");
speak(X) when is_integer(X) ->
  io:fwrite("Goodbye!~n");
speak(_) ->
  io:fwrite("Boom!~n").

main(_) ->
  speak(1.0), %=> Hello World!
  speak(1).   %=> Goodbye!
{% endhighlight %}

In this example we create a `speak/1` function which uses guard clauses to dispatch based on the type of the argument.
This code clearly implements type-based polymorphism, but it is very limited and very inelegant.

## Structure-based Polymorphism in Erlang

The main function dispatch mechanism in Erlang is pattern matching. Where pattern matching truly shines is when matching
against fields within a complex data structure such as a tuple. Consider this second example:

{% highlight erlang linenos %}
speak({phrase, hello}) ->
  io:fwrite("Hello World!~n");
speak({phrase, _}) ->
  io:fwrite("Goodbye!~n");
speak(_) ->
  io:fwrite("Boom!~n").

main(_) ->
  speak({phrase, hello}),    %=> Hello World!
  speak({phrase, goodbye}).  %=> Goodbye!
{% endhighlight %}

In this example we pass a tuple into the function and Erlang dispatches to the appropriate implementation based on the
*structure* of the tuple. In the first case it even matches against the data *within* the structure. This form of
function dispatch is both incredibly powerful, but also incredibly limiting. The first two functions will only match
a tuple with exactly two elements and where the first element is the atom `phrase`.

## Record-based Polymorphism in Erlang

Erlang extends the idea of structure-based polymorphism even farther with records. An Erlang `record` is similar to
a C `struct`. Erlang records define contiguous blocks of memory in which individual values can be stored based upon
field names. Consider this next example:

{% highlight erlang linenos %}
-record(foo, {phrase}).

speak(#foo{phrase = hello}) ->
  io:fwrite("Hello World!~n");
speak(#foo{phrase = _}) ->
  io:fwrite("Goodbye!~n");
speak(_) ->
  io:fwrite("Boom!~n").

main(_) ->
  speak(#foo{phrase = hello}),    %=> Hello World!
  speak(#foo{phrase = goodbye}).  %=> Goodbye!
{% endhighlight %}

In this example we define a record called `foo`, define a few functions which match against the structure of and
values within a `foo` record, then call our function. Erlang dispatches the function appropriately. What isn't
obvious from this example but which is important to note is that the pattern is only a partial match. Erlang
matches on the given fields but ignores all fields within the record that are not listed in the match. This means
that we can redfine our record:

{% highlight erlang linenos %}
-record(foo, {phrase, bar, baz}).
{% endhighlight %}

and the code still works the same. The pattern still matches against the `phrase` field but ignores the `bar`
and `baz` fields.

Erlang's pattern matching against complex data structure can also be combined with guard clauses this contrived
example shows:

{% highlight erlang linenos %}
-record(foo, {phrase, bar, baz}).

speak(#foo{phrase = hello}) ->
  io:fwrite("Hello World!~n");
speak(#foo{phrase = X}) when X =:= goodbye ->
  io:fwrite("Goodbye!~n");
speak(#foo{phrase = _}) ->
  io:fwrite("Bam!~n");
speak(_) ->
  io:fwrite("Boom!~n").

main(_) ->
  speak(#foo{phrase = hello}),    %=> "Hello World!"
  speak(#foo{phrase = goodbye}).  %=> "Goodbye!"
{% endhighlight %}

## Powerful But Limited

Erlang's pattern matching and guard clauses create an extremely robust, powerful, and flexible function dispatch
mechanism. But using it correctly requires a change in thinking from the type-based polymorphism common in many
mainstream programming languages. To be an effictive Erlang programmer one must embrace the dynamic type system
of Erlang and think in terms of data structure and their values rather than their types. Too heavy of an
emphasis on type will quickly lead to inelegant and difficult to maintain code.

Yet as powerful as Erlang's pattern matching and guard clauses are, Erlang isn't perfect. Records can be extremely
limiting because there is no way to cast between record types. If two records share a set of fields there is no
way for a single pattern to match against both record types. Two nearly identical patterns would have to be
created: one for each record type. Protocols in languages like Elixir and Clojure are one way to rectify this
shortcoming.
