%%%-------------------------------------------------------------------
%%% @author Gucio
%%% @copyright (C) 2025, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. Mar 2025 6:48 PM
%%%-------------------------------------------------------------------
-module(power).
-author("Gucio").

%% API
-export([power/2]).


power(_, 0) -> 1;
power(X, N) when N > 0 -> X * power(X, N - 1).
