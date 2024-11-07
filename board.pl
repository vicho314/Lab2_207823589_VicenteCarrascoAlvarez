use_module(library(apply)). /* filter, map, foldl*/
use_module(library(lists)).

non_zero(A):-
	A =\= 0.
non_zero_list(A,B):-
	exclude(non_zero,A,B).

/* TDA piece */
piece(Color,[Color]).

/* TDA board */
col_length_empty(L):-
	length(L,0).

col_length_notfull(L):-
	length(L,X),
	X < 6 .

/* Constructor */
board(Board):-
	length(Board1,7),
	include(col_length_empty,Board1,Board).

/* Selector */
board_col(Board,N,Col):-
	nth0(N,Board,Col).

/*fixme: foldl o scanl*/
board_fila(Board,N,Fila):-
	

can_play(Board):-
	include(col_length_notfull,Board,Board1),
	length(Board1,Notfullcols),
	Notfullcols > 0.

play_piece(Board,Col,Piece,NBoard):-
	
