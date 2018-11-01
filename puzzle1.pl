eats(wolf,goat).
eats(goat,cabbage).


survives([X, Y]) :- not(eats(X, Y)), not(eats(Y, X)).


can_be_left_alone(L) :- findall(Pair, pairs(L, Pair), Pairs), all(Pairs, survives).


just_moved([r|_]).
just_moved([l|_]).

just_moved(X, [r(X)|_]).
just_moved(X, [l(X)|_]).


puzzle(L, Order) :- puzzle(L, left, [], [], Order), !.

puzzle([], left, _, RevOrder, Order) :- reverse([r|RevOrder], Order).
puzzle([], right, _, RevOrder, Order) :- reverse(RevOrder, Order).

puzzle(L, left, R, AccOrder, Order) :- 
    not(just_moved(AccOrder)), 
    can_be_left_alone(L), 
    puzzle(L, right, R, [r|AccOrder], Order).

puzzle(L, left, R, AccOrder, Order) :- 
    elem(L, X, NL), 
    not(just_moved(X, AccOrder)), 
    can_be_left_alone(NL), 
    puzzle(NL, right, [X|R], [r(X)|AccOrder], Order).

puzzle(L, right, R, AccOrder, Order) :- 
    not(just_moved(AccOrder)), 
    can_be_left_alone(R), 
    puzzle(L, left, R, [l|AccOrder], Order).

puzzle(L, right, R, AccOrder, Order) :- 
    elem(R, X, NR), 
    not(just_moved(X, AccOrder)), 
    can_be_left_alone(NR), 
    puzzle([X|L], left, NR, [l(X)|AccOrder], Order).


all([], _).
all([H|T], P) :- call(P, H), all(T, P).


iter([X|_], X).
iter([_|T], X) :- iter(T, X).


pairs([X|T], [X,Y]) :- iter(T, Y).
pairs([_|T], Pair)  :- pairs(T, Pair).


reverse(List, Res) :- reverse(List, [], Res).

reverse([], Acc, Acc).
reverse([H|T], Acc, Res) :- reverse(T, [H|Acc], Res).


merge([], L2, L2).
merge([H|T], L2, L3) :- merge(T, [H|L2], L3).


elem(L, X, R) :- elem(L, [], X, R).
elem([X|T], Acc, X, R) :- merge(Acc, T, R).
elem([X|T], Acc, Z, R) :- elem(T, [X|Acc], Z, R).
