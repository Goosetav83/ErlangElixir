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
-export([create_monitor/0,add_station/3, add_value/5, remove_value/4]).
%Stations -> [Name, {X,Y}]
%Measurements -> [{Coords, Date, Type, Value}]
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

add_to_measurements(Coords,Date,Type,Value,Measurements)->
  M = [X || X<- Measurements, case X of
                                {Coords,Date,Type,_} -> true;
                                _ -> false
                              end],
  case M of
    [] -> [{Coords,Date,Type,Value}|Measurements];
    _->{error, "Invalid measurement"}
  end.

add_value(Identification, Date, Type, Value, #monitor{stations = Stations,measurements = Measurements} = Monitor)->
  Stat = case find_station(Identification,Stations,1) of
           0 -> {error, "Station not found"};
           X -> lists:nth(X,Stations)
         end,

  case Stat of
    {error, _} -> Stat;
    {_,Coords} -> case add_to_measurements(Coords,Date,Type,Value,Measurements) of
                    {error,_} -> {error, "Invalid measurement"};
                    M -> Monitor#monitor{measurements = M}
                  end
  end.


remove_value(Identification, Date, Type, #monitor{stations = Stations, measurements = Measurements} = Monitor) ->
  Stat = case find_station(Identification,Stations,1) of
           0 -> {error, "Station not found"};
           X -> lists:nth(X,Stations)
         end,
  case Stat of
    {error,_} -> Stat;
    {_,Coords} -> Monitor#monitor{measurements = [Z || Z<-Measurements, case Z of
                                                                          {Coords, Date, Type, _} ->false;
                                                                          _->true
                                                                        end]}
  end.



get_one_value(Identification, Date, Type, #monitor{stations = Stations, measurements = Measurements} = Monitor) ->
  Stat = case find_station(Identification,Stations,1) of
           0 -> {error, "Station not found"};
           X -> lists:nth(X,Stations)
         end,
  case Stat of
    {error,_} -> Stat;
    {_,Coords} ->lists:search(
                  fun
                    ({C, D, T, V}) when C =:= Coords, D =:= Date, T =:= Type -> V;
                    (_) -> {error, "Measurement not found"}
                  end, Measurements)
  end.

get_station_min(Identification, Type, #monitor{stations = Stations, measurements = Measurements} = Monitor) ->
  Stat = case find_station(Identification,Stations,1) of
           0 ->{error, "Station not found"};
           X -> lists:nth(X, Stations)
         end,
  case Stat of
    {error,_}-> Stat;
    {_,Coords} ->lists:min([element(4,V) || V<-Measurements, element(1,V)=:=Coords, element(3,V) =:= Type])
  end.

get_daily_mean(Date, Type, #monitor{stations = Stations, measurements = Measurements}=Monitor) ->
  Values = [element(4,V)|| V<-Measurements, element(2,V) =:= Date, element(3,V) =:= Type],
  lists:sum(Values)/length(Values).