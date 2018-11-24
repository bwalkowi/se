:- use_module(library(clpfd)).


solve(Options, Rows) :-
    sudoku(Rows),
    append(Rows, Vs),
    labeling(Options, Vs).

sudoku(Rows) :-
    Rows = [R1, R2, R3, R4, R5, R6, R7, R8, R9],
    
    distinct_rows(Rows),
    distinct_cols(Rows),

    distinct_blocks(R1, R2, R3),
    distinct_blocks(R4, R5, R6),
    distinct_blocks(R7, R8, R9).

distinct_rows([]).
distinct_rows([Row | RestRows]) :-
    length(Row, 9),
    Row ins 1..9,
    all_distinct(Row),
    distinct_rows(RestRows).

distinct_cols([[], [], [], [], [], [], [], [], []]).
distinct_cols([[X1|R1], [X2|R2], [X3|R3], [X4|R4], [X5|R5], [X6|R6], [X7|R7], [X8|R8], [X9|R9]]) :-
    all_distinct([X1, X2, X3, X4, X5, X6, X7, X8, X9]),
    distinct_cols([R1,R2,R3,R4,R5,R6,R7,R8,R9]).

distinct_blocks([], [], []).
distinct_blocks([X1, X2, X3 | Xs], [Y1, Y2, Y3 | Ys], [Z1, Z2, Z3 | Zs]) :-
    all_distinct([X1, X2, X3, Y1, Y2, Y3, Z1, Z2, Z3]),
    distinct_blocks(Xs, Ys, Zs).
