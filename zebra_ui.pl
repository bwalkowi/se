person([who(_), house(_), drinks(_), smokes(_), owns(_)]).
property(P, A) :- person(A), member(P, A).

constraint(P1, P2, L) :- property(P1, A), property(P2, A), member(A, L).

constraint_at(0, P, [H | _]) :- property(P, H).
constraint_at(I, P, [_ | T]) :- J is I-1, constraint_at(J, P, T).

constraint_left(PL, PR, [L, R | _]) :- property(PL, L), property(PR, R).
constraint_left(PL, PR, [_ | T]) :- constraint_left(PL, PR, T).

constraint_next(PA, PB, L) :- constraint_left(PA, PB, L).
constraint_next(PA, PB, L) :- constraint_left(PB, PA, L).

zebra(People) :-
  open('constraints.txt',read,Str),
  read_constraints(Str, Constraints),
  !,
  close(Str),
  % write(Constraints), nl,
  length(People, 5),
  constraint_at(2, drinks("milk"), People),
  constraint_at(0, who("norwegian"), People),
  validate_constraints(Constraints, People).

read_constraints(Stream,[]) :- at_end_of_stream(Stream).

read_constraints(Stream,[X|L]) :-
  \+ at_end_of_stream(Stream),
  read(Stream,X),
  read_constraints(Stream,L).

% last element is the end of file marker
validate_constraints([_], _).

validate_constraints([H|T], People) :-
  % write(H), nl,
  split_string(H, " ", "", L),
  apply_constraint(L, People),
  validate_constraints(T, People).

apply_constraint(["who" | L], People) :-
  append(X, ["lives", RP, "to", "one", "who" | Y], L),
  parse_constraint(X, C1),
  parse_constraint(Y, C2),
  constraint_relative_pos(C1, C2, RP, People).

apply_constraint(["who" | L], People) :-
  append(X, Y, L),
  parse_constraint(X, C1),
  parse_constraint(Y, C2),
  constraint(C1, C2, People).

apply_constraint([X, "lives", RP, "to", "one", "who" | Y], People) :-
  parse_constraint(Y, C), constraint_relative_pos(who(X), C, RP, People).

apply_constraint([X | Y], People) :-
  parse_constraint(Y, C), constraint(who(X), C, People).

parse_constraint(["lives", "in", X, "house"], house(X)).
parse_constraint(["drinks", X], drinks(X)).
parse_constraint(["owns", X], owns(X)).
parse_constraint(["smokes", X], smokes(X)).

constraint_relative_pos(C1, C2, "next", People) :- constraint_next(C1, C2, People).
constraint_relative_pos(C1, C2, "left", People) :- constraint_left(C1, C2, People).
constraint_relative_pos(C1, C2, "right", People) :- constraint_left(C2, C1, People).
