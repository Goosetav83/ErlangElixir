-module(pollution_server).
-author("maste").

%% API
-export([start/0, stop/0, init/0, create_monitor/0, add_station/2, add_value/4, remove_value/3, 
get_one_value/3, get_station_min/2, get_daily_mean/2, get_area_mean/3]).


% Startuje serwer
start() ->
    register(pollution_server, spawn(?MODULE, init, [])).

% Inicjalizuje serwer
init() ->
    loop(pollution:create_monitor()).

% Zatrzymuje serwer
stop() ->
    pollution_server ! {self(), stop},
    receive
        {_, ok} -> ok
    after 1000 ->
        {error, timeout}
    end.

% Główna pętla serwera
loop(Monitor) ->
    receive
        {Pid, create_monitor} ->
            NewMonitor = pollution:create_monitor(),
            Pid ! {self(), ok},
            loop(NewMonitor);
            
        {Pid, {add_station, Name, Coords}} ->
            Result = pollution:add_station(Name, Coords, Monitor),
            case Result of
                {error, Reason} ->
                    Pid ! {self(), {error, Reason}},
                    loop(Monitor);
                NewMonitor ->
                    Pid ! {self(), ok},
                    loop(NewMonitor)
            end;
            
        {Pid, {add_value, Identification, DateTime, Type, Value}} ->
            Result = pollution:add_value(Identification, DateTime, Type, Value, Monitor),
            case Result of
                {error, Reason} ->
                    Pid ! {self(), {error, Reason}},
                    loop(Monitor);
                NewMonitor ->
                    Pid ! {self(), ok},
                    loop(NewMonitor)
            end;
            
        {Pid, {remove_value, Identification, DateTime, Type}} ->
            Result = pollution:remove_value(Identification, DateTime, Type, Monitor),
            case Result of
                {error, Reason} ->
                    Pid ! {self(), {error, Reason}},
                    loop(Monitor);
                NewMonitor ->
                    Pid ! {self(), ok},
                    loop(NewMonitor)
            end;
            
        {Pid, {get_one_value, Identification, DateTime, Type}} ->
            Result = pollution:get_one_value(Identification, DateTime, Type, Monitor),
            Pid ! {self(), Result},
            loop(Monitor);
            
        {Pid, {get_station_min, Identification, Type}} ->
            Result = pollution:get_station_min(Identification, Type, Monitor),
            Pid ! {self(), Result},
            loop(Monitor);
            
        {Pid, {get_daily_mean, Type, Date}} ->
            Result = pollution:get_daily_mean(Type, Date, Monitor),
            Pid ! {self(), Result},
            loop(Monitor);
            
        {Pid, {get_area_mean, Type, Position, Radius}} ->
            Result = pollution:get_area_mean(Type, Position, Radius, Monitor),
            Pid ! {self(), Result},
            loop(Monitor);
            
        {Pid, stop} ->
            Pid ! {self(), ok};
            
        _ ->
            loop(Monitor)
    end.

% Funkcje interfejsu klienta
create_monitor() ->
    pollution_server ! {self(), create_monitor},
    receive
        {_, Response} -> Response
    after 1000 ->
        {error, timeout}
    end.

add_station(Name, Coords) ->
    pollution_server ! {self(), {add_station, Name, Coords}},
    receive
        {_, Response} -> Response
    after 1000 ->
        {error, timeout}
    end.

add_value(Identification, DateTime, Type, Value) ->
    pollution_server ! {self(), {add_value, Identification, DateTime, Type, Value}},
    receive
        {_, Response} -> Response
    after 1000 ->
        {error, timeout}
    end.

remove_value(Identification, DateTime, Type) ->
    pollution_server ! {self(), {remove_value, Identification, DateTime, Type}},
    receive
        {_, Response} -> Response
    after 1000 ->
        {error, timeout}
    end.
get_one_value(Identification, DateTime, Type) ->
    pollution_server ! {self(), {get_one_value, Identification, DateTime, Type}},
    receive
        {_, Response} -> Response
    after 1000 ->
        {error, timeout}
    end.

get_station_min(Identification, Type) ->
    pollution_server ! {self(), {get_station_min, Identification, Type}},
    receive
        {_, Response} -> Response
    after 1000 ->
        {error, timeout}
    end.

get_daily_mean(Type, Date) ->
    pollution_server ! {self(), {get_daily_mean, Type, Date}},
    receive
        {_, Response} -> Response
    after 1000 ->
        {error, timeout}
    end.

get_area_mean(Type, Position, Radius) ->
    pollution_server ! {self(), {get_area_mean, Type, Position, Radius}},
    receive
        {_, Response} -> Response
    after 1000 ->
        {error, timeout}
    end.