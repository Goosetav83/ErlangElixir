%%%-------------------------------------------------------------------
%%% @author maste
%%% @copyright (C) 2025, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. mar 2025 14:17
%%%-------------------------------------------------------------------
-module(sensor_dist).
-author("maste").

%% API
-export([measure_time/1, find_closest_con/2,find_for_person/2,find_for_person/3,get_random_locations/1,dist/2,find_closest/2]).

get_random_locations(N)->
  [{rand:uniform(10000),rand:uniform(10000)} || _ <- lists:seq(1, N)].

dist({X1,Y1},{X2,Y2}) -> math:sqrt((X1-X2)*(X1-X2) + (Y1-Y2)*(Y1-Y2)).

find_for_person(PersonLocation, SensorsLocations) ->
  lists:min([{dist(PersonLocation, SL), {PersonLocation,SL}} ||SL <- SensorsLocations]).

find_closest(PeopleLocations, SensorsLocations) ->
  lists:min([{find_for_person(P, SensorsLocations), P} || P <- PeopleLocations]).

find_for_person(PersonLocation,SensorsLocations, ParentPID)->
  ParentPID ! find_for_person(PersonLocation, SensorsLocations).

find_closest_con(PeopleLocations, SensorsLocations) ->
  PIDs = [spawn(?MODULE,find_for_person,[P, SensorsLocations, self()]) || P <- PeopleLocations],
  lists:min([receive D -> D end || _ <- PIDs]).

measure_time(N) ->
  PeopleLocations = get_random_locations(N),
  SensorsLocations = get_random_locations(N),
  {T1,_} = timer:tc(sensor_dist, find_closest, [PeopleLocations, SensorsLocations]),
  {T2,_} = timer:tc(sensor_dist, find_closest_con, [PeopleLocations, SensorsLocations]),
  io:format("Czas dla ~w osob: ~wms ~n",[N, T1/1000]),
  io:format("Czas dla ~w osob z procesami: ~wms ~n",[N, T2/1000]).