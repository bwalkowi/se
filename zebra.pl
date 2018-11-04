person([who(_), house(_), drinks(_), smokes(_), owns(_)]).
property(P, A) :- person(A), member(P, A).

constraint(P1, P2, L) :- property(P1, A), property(P2, A), member(A, L).
constraint(P, L) :- property(P, A), member(A, L).

constraint_at(0, P, [H | _]) :- property(P, H).
constraint_at(I, P, [_ | T]) :- J is I-1, constraint_at(J, P, T).

constraint_left(PL, PR, [L, R | _]) :- property(PL, L), property(PR, R).
constraint_left(PL, PR, [_ | T]) :- constraint_left(PL, PR, T).

constraint_next(PA, PB, L) :- constraint_left(PA, PB, L).
constraint_next(PA, PB, L) :- constraint_left(PB, PA, L).

zebra(People) :-
  length(People, 5),
  constraint(house(red), who(englishman), People),
  constraint(who(spaniard), owns(dog), People),
  constraint(house(green), drinks(coffee), People),
  constraint(who(ukrainian), drinks(tea), People),
  constraint_left(house(ivory), house(green), People),
  constraint(smokes(old_gold), owns(snails), People),
  constraint(house(yellow), smokes(kools), People),
  constraint_at(2, drinks(milk), People),
  constraint_at(0, who(norwegian), People),
  constraint_next(smokes(chesterfields), owns(fox), People),
  constraint_next(smokes(kools), owns(horse), People),
  constraint(drinks(juice), smokes(lucky), People),
  constraint(who(japanese), smokes(parliaments), People),
  constraint_next(who(norwegian), house(blue), People),
  constraint(drinks(water), People),
  constraint(owns(zebra), People).
