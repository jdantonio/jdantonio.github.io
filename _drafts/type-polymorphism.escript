#!/usr/bin/env escript
%% -*- erlang -*-

-record(foo, {phrase, bar, baz}).

%speak(X) when is_float(X) ->
  %io:fwrite("Hello World!~n");
%speak(X) when is_integer(X) ->
  %io:fwrite("Goodbye!~n");
%speak({phrase, hello}) ->
  %io:fwrite("Hello World!~n");
%speak({phrase, _}) ->
  %io:fwrite("Goodbye!~n");
speak(#foo{phrase = hello}) ->
  io:fwrite("Hello World!~n");
speak(#foo{phrase = X}) when X =:= goodbye ->
  io:fwrite("Goodbye!~n");
speak(#foo{phrase = _}) ->
  io:fwrite("Bam!~n");
speak(_) ->
  io:fwrite("Boom!~n").

main(_) ->
  %speak(1.0),  %=> "Hello World!"  
  %speak(1),    %=> "Goodbye!"
  %speak({phrase, hello}),    %=> "Hello World!"
  %speak({phrase, goodbye}),  %=> "Goodbye!"
  speak(#foo{phrase = hello}),    %=> "Hello World!"
  speak(#foo{phrase = goodbye}).  %=> "Goodbye!"



%% %%! -smp enable -sname factorial -mnesia debug verbose
%% main([String]) ->
%%     try
%%         N = list_to_integer(String),
%%         F = fac(N),
%%         io:format("factorial ~w = ~w\n", [N,F])
%%     catch
%%         _:_ ->
%%             usage()
%%     end;
%% main(_) ->
%%     usage().
%% 
%% usage() ->
%%     io:format("usage: factorial integer\n"),
%%     halt(1).
%% 
%% fac(0) -> 1;
%% fac(N) -> N * fac(N-1).
