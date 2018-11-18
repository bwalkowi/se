/*
Assign different values 0-9 to all letters S,E,N,D,M,O,R,Y 
in such a way that the equation holds
   SEND+
   MORE
   -----
   MONEY
*/

:- use_module(library(clpfd)).


puzzle(Words, Letters) :-
    all_distinct(Letters),

    check_sum(Words),
    label(Letters).

check_sum(Words) :- check_sum(Words, 0).

check_sum([W], SumSoFar) :- 
    W ins 0..9, stoi(W, N),
    SumSoFar #= N.
check_sum([W|T], SumSoFar0) :-
    W ins 0..9, stoi(W, N),
    SumSoFar1 #= SumSoFar0 + N,
    check_sum(T, SumSoFar1).

stoi(S, N) :- stoi(S, 0, N).

stoi([], N, N).
stoi([X|T], Acc0, N) :- 
    Acc1 #= Acc0 * 10 + X, 
    stoi(T, Acc1, N).
