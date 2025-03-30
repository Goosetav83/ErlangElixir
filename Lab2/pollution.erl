%%%-------------------------------------------------------------------
%%% @author maste
%%% @copyright (C) 2025, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. mar 2025 14:38
%%%-------------------------------------------------------------------
-module(pollution).
-author("maste").

%% API
-export([create_monitor/0,add_station/3, add_value/5, remove_value/4, get_one_value/4,get_station_min/3,get_daily_mean/3,get_area_mean/4]).
%Stations -> [Name, {X,Y}]
%Measurements -> [{Coords, {Date, Time}, Type, Value}]
-record(monitor, {stations = [], measurements = []}).

create_monitor()->#monitor{}.

add_station(Name, {X,Y}, #monitor{stations = Stations} = Monitor)->
    Temp = [Z || Z<-Stations, case Z of
                                {Name, _} -> true;
                                {_,{X,Y}} -> true;
                                _ -> false
                              end],
    case Temp of
      [] -> Monitor#monitor{stations = [{Name,{X,Y}}|Stations]};
      _ -> {error, "Station or coordinates already exist"}
    end.

%%% Finds index of the stations
find_station(_,[],_)->0;

find_station(Identification,[H|Stations],I)->
  case H of
    {Identification,_} -> I;
    {_,Identification} -> I;
    _ -> find_station(Identification, Stations, I+1)
  end.

add_to_measurements(Coords,DateTime,Type,Value,Measurements)->
  M = [X || X<- Measurements, case X of
                                {Coords,DateTime,Type,_} -> true;
                                _ -> false
                              end],
  case M of
    [] -> [{Coords,DateTime,Type,Value}|Measurements];
    _->{error, "Invalid measurement"}
  end.

add_value(Identification, DateTime, Type, Value, #monitor{stations = Stations,measurements = Measurements} = Monitor)->
  Stat = case find_station(Identification,Stations,1) of
           0 -> {error, "Station not found"};
           X -> lists:nth(X,Stations)
         end,

  case Stat of
    {error, _} -> Stat;
    {_,Coords} -> case add_to_measurements(Coords,DateTime,Type,Value,Measurements) of
                    {error,_} -> {error, "Invalid measurement"};
                    M -> Monitor#monitor{measurements = M}
                  end
  end.


remove_value(Identification, DateTime, Type, #monitor{stations = Stations, measurements = Measurements} = Monitor) ->
  Stat = case find_station(Identification,Stations,1) of
           0 -> {error, "Station not found"};
           X -> lists:nth(X,Stations)
         end,
  NewMeasurement = case Stat of
    {error,_} -> Stat;
    {_,Coords} -> [X || X<-Measurements, case X of
                                           {Coords,DateTime,Type,_} -> false;
                                           _ -> true
                                         end]
  end,
  case NewMeasurement of
    {error,_} -> NewMeasurement;
    Measurements -> {error, "Measurement not found"};
    _ -> Monitor#monitor{measurements = NewMeasurement}
end.

get_one_value(Identification, DateTime, Type, #monitor{stations = Stations, measurements = Measurements}) ->
  Stat = case find_station(Identification,Stations,1) of
           0 -> {error, "Station not found"};
           X -> lists:nth(X,Stations)
         end,
  case Stat of
    {error,_} -> Stat;
    {_,Coords} ->case [V || {C,DT,T,V}<-Measurements, C=:= Coords, DT =:= DateTime, T=:=Type] of
                   [] -> {error, "Measurement not found"};
                   [V|_] -> V
                 end
  end.

get_station_min(Identification, Type, #monitor{stations = Stations, measurements = Measurements}) ->
  Stat = case find_station(Identification,Stations,1) of
           0 ->{error, "Station not found"};
           X -> lists:nth(X, Stations)
         end,
  case Stat of
    {error,_}-> Stat;
    {_,Coords} -> M = ([V || {C,_,T,V}<-Measurements,C =:= Coords ,T=:=Type]),
                case M of
                  [] -> {error, "No measurements"};
                  _ -> lists:min(M)
                end
  end.

get_daily_mean(Type,Date, #monitor{measurements = Measurements}) ->
  Values = [V || {_,{D,_},T,V} <- Measurements,D ==Date, T==Type],
  case Values of
    [] -> {error, "No measurements"};
    _ -> lists:sum(Values)/length(Values)
  end.

get_area_mean(Type, {X,Y}, Radius, #monitor{measurements = Measurements}) ->
  M = [V || {{X1,Y1}, _, T, V} <- Measurements, T == Type, math:sqrt((X1-X)*(X1-X) + (Y1-Y)*(Y1-Y)) =< Radius],
  case M of
    [] -> {error, "No measurements"};
    _ -> lists:sum(M)/length(M)
  end.