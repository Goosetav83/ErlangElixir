%%%-------------------------------------------------------------------
%%% @author maste
%%% @copyright (C) 2025, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. mar 2025 13:33
%%%-------------------------------------------------------------------
-module(qsort).
-author("maste").

%% API
-export([qs/1, random_elems/3, compare_speeds/3]).


less_than(List, Arg) -> [X || X<-List, X<Arg].

grt_eq_than(List, Arg) -> [X || X<-List, X>=Arg].

qs([]) -> [];
qs([Pivot|Tail]) -> qs( less_than(Tail,Pivot) ) ++ [Pivot] ++ qs( grt_eq_than(Tail,Pivot) ).


random_elems(N,Min,Max) -> [X || _ <- lists:seq(1,N), X <- [rand:uniform(Max-Min) + Min]].

compare_speeds(List, Fun1, Fun2) ->
  {T1,_} = timer:tc(Fun1,[List]),
  {T2, _} = timer:tc(Fun2,[List]),
  io:format("Czas Fun1: ~wms ~n",[T1/1000]),
  io:format("Czas Fun2: ~wms ~n",[T2/1000]).