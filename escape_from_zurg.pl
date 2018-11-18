/*
There are toys who would all like to cross a rickety old bridge. 
The old bridge will only support 2 toys at a time, and it is night time,
so every crossing must use the one flashlight that they all share. 
The toys each have different walking speeds; 
If they pair up, since they must share the flashlight, 
they can only cross in the time that it would take the slower of the two. 
Given upper time limit before the bridge will fall apart, 
how should they all cross?
*/

:- use_module(library(clpfd)).


escape_time(buzz, 5).
escape_time(woody, 10).
escape_time(rex, 20).
escape_time(hamm, 25).


puzzle(Toys, Time, Moves) :-
    on_left(Toys, [], Time, Moves).

on_left(L0, R, Time0, [left_to_right(X,Y)|Moves]) :-
    select(X, L0, L1),
    select(Y, L1, L2),
    X @< Y,

    escape_time(X, XTime),
    escape_time(Y, YTime),

    Time1 #= Time0 - max(XTime, YTime),
    on_right(L2, [X,Y|R], Time1, Moves).

on_right([], _, 0, []).
on_right(L, R0, Time0, [right_to_left(X)|Moves]) :-
    select(X, R0, R1),
    escape_time(X, XTime),
    Time1 #= Time0 - XTime,
    on_left([X|L], R1, Time1, Moves).
