%%%-------------------------------------------------------------------
%%% @copyright (C) 2025, <COMPANY>
%%% @author Goosetav83
%%% @doc
%%%
%%% @end
%%% Created : 16. Mar 2025 3:53 PM
%%%-------------------------------------------------------------------
-module(kalkulator).
-author("Goosetav83").

%% API
-export([dane/0,number_of_reading/2,calculate_max/2,calculate_mean/2]).

dane() ->
  [
    ["First Station", {2024, 2, 14}, {15, 30, 13}, [{"PM10", 10.0}, {"PM2.5", 2.5}, {"PM1", 1.0}, {"temperatura", 17.3}, {"wilgotnosc", 80.3}, {"cisnienie", 1013.4},{"dummy_mean", 1.0}]],
    ["First Station", {2024, 2, 15}, {16, 00, 21}, [{"PM10", 12.0}, {"PM2.5", 3.0}, {"PM1", 1.2}, {"temperatura", 18.1}, {"wilgotnosc", 78.2}, {"cisnienie", 1012.2},{"dummy_mean", 2.0}]],
    ["First Station", {2024, 2, 16}, {14, 45, 0}, [{"PM10", 11.5}, {"PM2.5", 2.8}, {"PM1", 1.1}, {"temperatura", 19.5}, {"wilgotnosc", 76.0}, {"cisnienie", 1011.3},{"dummy_mean", 3.0}]],

    ["Second Station", {2024, 2, 14}, {12, 15, 0}, [{"PM2.5", 8.2}, {"PM1", 3.1}, {"temperatura", 20.3}, {"wilgotnosc", 75.2}, {"cisnienie", 1011.4},{"dummy_mean", 1.0}]],
    ["Second Station", {2024, 3, 11}, {13, 20, 33}, [{"PM2.5", 7.5}, {"PM1", 2.9}, {"temperatura", 21.3}, {"wilgotnosc", 72.4}, {"cisnienie", 1010.6},{"dummy_mean", 2.0}]],
    ["Second Station", {2024, 3, 12}, {14, 10, 51}, [{"PM2.5", 7.8}, {"PM1", 3.0}, {"temperatura", 22.3}, {"wilgotnosc", 70.6}, {"cisnienie", 1009.6},{"dummy_mean", 3.0}]],

    ["Third Station", {2024, 2, 14}, {8, 45, 22}, [{"PM10", 15.4}, {"PM2.5", 5.7}, {"wilgotnosc", 60.4}, {"cisnienie", 1009.2}]],
    ["Third Station", {2024, 3, 11}, {9, 32, 0}, [{"PM10", 14.8}, {"PM2.5", 6.1}, {"wilgotnosc", 62.1}, {"cisnienie", 1010.1}]],
    ["Third Station", {2024, 4, 16}, {10, 20, 1}, [{"PM10", 16.2}, {"PM2.5", 5.9}, {"wilgotnosc", 63.4}, {"cisnienie", 1011.1}]],

    ["Fourth Station", {2024, 12, 22}, {18, 43, 3}, [{"PM10", 25.0}, {"PM2.5", 10.2}, {"PM1", 4.5}, {"temperatura", 5.1}, {"wilgotnosc", 85.7},{"dummy_mean", 1.0}]],
    ["Fourth Station", {2024, 12, 23}, {19, 11, 30}, [{"PM10", 26.1}, {"PM2.5", 9.8}, {"PM1", 4.3}, {"temperatura", 4.0}, {"wilgotnosc", 87.8},{"dummy_mean", 2.0}]],
    ["Fourth Station", {2024, 12, 24}, {20, 22, 56}, [{"PM10", 24.5}, {"PM2.5", 10.5}, {"PM1", 4.7}, {"temperatura", 6.5}, {"wilgotnosc", 86.9},{"dummy_mean", 3.0}]],

    ["Fifth Station", {2024, 3, 11}, {6, 30, 28}, [{"PM1", 2.0}, {"temperatura", 12.2}, {"cisnienie", 1020.0}]],
    ["Fifth Station", {2024, 3, 12}, {7, 51, 35}, [{"PM1", 2.3}, {"temperatura", 13.5}, {"cisnienie", 1019.1}]],
    ["Fifth Station", {2024, 4, 1}, {8, 13, 0}, [{"PM1", 2.1}, {"temperatura", 14.9}, {"cisnienie", 1018.2}]],

    ["Sixth Station", {2024, 7, 14}, {14, 28, 0}, [{"PM10", 18.7}, {"temperatura", 25.6}, {"wilgotnosc", 70.3},{"dummy_mean", 1.0}]],
    ["Sixth Station", {2024, 7, 28}, {15, 45, 55}, [{"PM10", 19.2}, {"temperatura", 26.2}, {"wilgotnosc", 68.2},{"dummy_mean", 2.0}]],
    ["Sixth Station", {2024, 8, 11}, {16, 33, 22}, [{"PM10", 17.8}, {"temperatura", 24.5}, {"wilgotnosc", 71.9},{"dummy_mean", 3.0}]],

    ["Seventh Station", {2024, 9, 1}, {20, 56, 44}, [{"PM10", 40.5}, {"PM2.5", 22.3}, {"PM1", 12.1}, {"temperatura", 30.0}, {"wilgotnosc", 60.4}, {"cisnienie", 1005.0},{"dummy_mean", 1.0}]],
    ["Seventh Station", {2024, 9, 3}, {21, 33, 14}, [{"PM10", 42.0}, {"PM2.5", 21.8}, {"PM1", 11.5}, {"temperatura", 29.5}, {"wilgotnosc", 58.5}, {"cisnienie", 1006.0},{"dummy_mean", 2.0}]],
    ["Seventh Station", {2024, 9, 5}, {22, 19, 56}, [{"PM10", 41.2}, {"PM2.5", 20.5}, {"PM1", 10.8}, {"temperatura", 28.9}, {"wilgotnosc", 53.8}, {"cisnienie", 1004.1},{"dummy_mean", 3.0}]],

    ["Eigth Station", {2024, 6, 3}, {10, 50, 31}, [{"PM2.5", 3.5}, {"temperatura", 18.3}, {"wilgotnosc", 90.4}, {"cisnienie", 1018.5},{"dummy_mean", 1.0}]],
    ["Eigth Station", {2024, 6, 4}, {11, 15, 15}, [{"PM2.5", 3.7}, {"temperatura", 19.0}, {"wilgotnosc", 88.4}, {"cisnienie", 1017.0},{"dummy_mean", 2.0}]],
    ["Eigth Station", {2024, 6, 5}, {12, 12, 44}, [{"PM2.5", 3.6}, {"temperatura", 20.1}, {"wilgotnosc", 89.8}, {"cisnienie", 1016.0},{"dummy_mean", 3.0}]]
  ].


number_of_reading([],_) -> 0;
number_of_reading([H|T], Date) ->
case lists:nth(2, H) of
Date -> 1 + number_of_reading(T, Date);
_ -> number_of_reading(T, Date)
end.

find_value([], _) -> not_found;
find_value([{Type, Value}|_], Type) -> Value;
find_value([_|T], Type) -> find_value(T, Type).

calculate_max(Readings, Type) ->
  case lists:member(Type, ["PM10", "PM2.5", "PM1", "temperatura", "wilgotnosc", "cisnienie","dummy_mean"]) of
    true -> calculate_max_checked(Readings,Type);
    false -> wrong_type
  end.

calculate_max_checked([], _)->0.0;
calculate_max_checked([H|T], Type) ->
  Val = find_value(lists:nth(4, H),Type),
  case Val of
    not_found -> calculate_max_checked(T, Type);
    _ -> max(Val, calculate_max_checked(T, Type))
  end.



calculate_mean(Readings, Type) ->
  case lists:member(Type, ["PM10", "PM2.5", "PM1", "temperatura", "wilgotnosc", "cisnienie","dummy_mean"]) of
    true ->
      {L,M} = calculate_mean_checked(Readings,Type),
      L/M;
    false -> wrong_type
  end.

calculate_mean_checked([], _)-> {0.0,0.0};
calculate_mean_checked([H|T], Type) ->
  Val = find_value(lists:nth(4, H),Type),
  case Val of
    not_found -> calculate_mean_checked(T, Type);
    _ ->
      {L,M} = calculate_mean_checked(T, Type),
      {L+Val,M+1}
  end.
