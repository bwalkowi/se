/*
Given statements
1. Only one of these statements is false
2. Only two of these statements is false
3. Only three of these statements is false
4. Only four of these statements is false
5. All five of these statements is false
Which if any is true?
*/

:- use_module(library(clpb)).

puzzle([A, B, C, D, E]) :-
    sat(A =:= card([1],[~A, ~B, ~C, ~D, ~E])),
    sat(B =:= card([2],[~A, ~B, ~C, ~D, ~E])),
    sat(C =:= card([3],[~A, ~B, ~C, ~D, ~E])),
    sat(D =:= card([4],[~A, ~B, ~C, ~D, ~E])),
    sat(E =:= card([5],[~A, ~B, ~C, ~D, ~E])).
