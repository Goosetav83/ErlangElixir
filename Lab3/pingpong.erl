%%%-------------------------------------------------------------------
%%% @author maste
%%% @copyright (C) 2025, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. mar 2025 13:25
%%%-------------------------------------------------------------------
-module(pingpong).
-author("maste").

%% API
-export([start/0,ping_loop/0,pong_loop/0]).

start()->
  register(ping,spawn( ?MODULE, ping_loop, [])),
  register(pong,spawn(?MODULE, pong_loop, [])),
  ping ! 10.

stop() ->
  ok.

ping_loop()->
  receive
    0 -> io:format("ping ~w ~n",[0]),
          ping_loop();
    N -> io:format("ping ~w ~n", [N]),
        timer:sleep(1000),
        pong ! N-1,
        ping_loop()
  after 5000 -> stop()
  end.

pong_loop()->
  receive
    0 -> io:format("pong ~w ~n", [0]),
          pong_loop();
    N -> io:format("pong ~w ~n", [N]),
        timer:sleep(1000),
        ping ! N-1,
        pong_loop()
  after 5000 -> stop()
  end.