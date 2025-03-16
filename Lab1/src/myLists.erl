%%%-------------------------------------------------------------------
%%% @author Goosetav83
%%% @copyright (C) 2025, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. Mar 2025 7:00 PM
%%%-------------------------------------------------------------------
-module(myLists).
-author("Goosetav83").

%% API
-export([contains/2, duplicateElements/1, sumFloats/1]).

contains(_, []) -> false;
contains(X, [H|T]) -> X == H orelse contains(X, T).

duplicateElements([]) -> [];
duplicateElements([H|T]) -> [H, H|duplicateElements(T)].

sumFloats([]) -> 0;
sumFloats([H|T]) when is_float(H) -> H + sumFloats(T);
sumFloats([_|T]) -> sumFloats(T).