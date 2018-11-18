/*
You are on an island where every inhabitant is either a knight or a knave. 
Knights always tell the truth, and knaves always lie. 

You meet 2 inhabitants, A and B. A says: "Either I am a knave or B is a knight."
*/

:- use_module(library(clpb)).
 
puzzle([A,B]) :-
    sat(A =:= ~A + B).
