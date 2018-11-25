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
  open('zebra_constraints.txt', read, Stream),
  read_constraints(Stream, Constraints),
  close(Stream),
  validate_constraints(Constraints, People).

read_constraints(Stream, []) :- at_end_of_stream(Stream), !.

read_constraints(Stream, [X|L]) :-
  read(Stream, X),
  read_constraints(Stream, L).

% last element is the end of file marker
validate_constraints([end_of_file], _).

validate_constraints([H|T], People) :-
  string_lower(H, S),
  split_string(S, " ,.", "", L0),
  exclude(exclude_word, L0, L),
  apply_constraint(L, People),
  validate_constraints(T, People).

exclude_word("the").
exclude_word("a").
exclude_word("an").
exclude_word("").

apply_constraint(["there", "are", X, "houses"], People) :-
  atom_number(X, N),
  length(People, N).

apply_constraint(["who" | L], People) :-
  append(X, ["lives", RP, "to", "one", "who" | Y], L),
  parse_constraint(X, C1),
  parse_constraint(Y, C2),
  constraint_relative_pos(C1, C2, RP, People).

apply_constraint(["who" | L], People) :-
  append(X, ["lives",  "at", Y], L),
  parse_constraint(X, C),
  atom_number(Y, N),
  constraint_at(N, C, People).

apply_constraint(["who" | L], People) :-
  append(X, Y, L),
  parse_constraint(X, C1),
  parse_constraint(Y, C2),
  constraint(C1, C2, People).

apply_constraint([X, "lives", RP, "to", "one", "who" | Y], People) :-
  parse_constraint(Y, C), constraint_relative_pos(who(X), C, RP, People).

apply_constraint([X, "lives",  "at", Y], People) :-
  atom_number(Y, N),
  constraint_at(N, who(X), People).

apply_constraint([X | Y], People) :-
  parse_constraint(Y, C), constraint(who(X), C, People).

parse_constraint(["lives", "in", X, "house"], house(X)).
parse_constraint(["drinks", X], drinks(X)).
parse_constraint(["owns", X], owns(X)).
parse_constraint(["smokes", X], smokes(X)).

constraint_relative_pos(C1, C2, "next", People) :- constraint_next(C1, C2, People).
constraint_relative_pos(C1, C2, "left", People) :- constraint_left(C1, C2, People).
constraint_relative_pos(C1, C2, "right", People) :- constraint_left(C2, C1, People).
