:- use_module(library(apply)). /* filter, map, foldl*/
:- consult(utils).
:- use_module(library(lists)).

non_zero(A):-
	A =\= 0.

non_zero_list(A,B):-
	include(non_zero,A,B).

zero_fill(L2,Len,L2):-
	length(L2,K),
	K is Len,
	!.

zero_fill(L,Len,L2):-
	length(L,K),
	K < Len,
	append(L,[0],L1),
	zero_fill(L1,Len,L2).

value_fill(L2,Len,_,L2):-
	length(L2,K),
	K is Len,
	!.

value_fill(L,Len,V,L2):-
	length(L,K),
	K < Len,
	append(L,[V],L1),
	value_fill(L1,Len,V,L2).

/* TDA piece */
piece(Color,[Color]).

/*Mala idea, blame RF.*/
hash_piece(["red"],1).
hash_piece(["yellow"],2).
hash_piece(0,0).

/* TDA board */
col_length_empty(L):-
	length(L,0).

col_length_notfull(L):-
	length(L,X),
	X < 6 .

/* Constructor */

/*
board(Board):-
	length(Board1,7),
	include(col_length_empty,Board1,Board2).
*/
board(Board):-
	zero_fill([],6,EmptyCol),
	value_fill([],7,EmptyCol,Board).

/* Selector */
board_col(Board,N,Col):-
	nth0(N,Board,Col).

/*fixme: foldl o scanl*/
board_fila(Board,N,Fila):-
	transpose(Board,B2),
	board_col(B2,N,Fila).

board_getxy(Board,X,Y,V):-
	nth0(X,Board,Col),
	nth0(Y,Col,V).		

can_play(Board):-
	include(col_length_notfull,Board,Board1),
	length(Board1,Notfullcols),
	Notfullcols > 0.

play_piece(Board,Col,Piece,NBoard):-
	board_col(Board,Col,C),
	non_zero_list(C,C2),
	append(C2,[Piece],NewC),
	zero_fill(NewC,6,NewC2),
	write_list(Board,Col,NewC2,NBoard).

in_bounds(X,Y):-
	X < 7,
	X >= 0,
	Y < 6,
	Y >= 0.

diag_ascen_get(_,X,Y,_,B):-
	not(in_bounds(X,Y)),
	length(B,K),
	K > 3,
	K =< 6,
	!.

diag_ascen_get(A,X,Y,C,B):-
        in_bounds(X,Y),
        board_getxy(A,X,Y,V0),
        nth0(C,B,V0),
        K is C+1,
        X2 is X+1,
        Y2 is Y+1,
        diag_ascen_get(A,X2,Y2,K,B).

diag_descen_get(_,X,Y,_,B):-
	not(in_bounds(X,Y)),
	length(B,K),
	K > 3,
	K =< 6,
	!.

diag_descen_get(A,X,Y,C,B):-
        in_bounds(X,Y),
        board_getxy(A,X,Y,V0),
        nth0(C,B,V0),
        K is C+1,
        X2 is X-1,
        Y2 is Y-1,
        diag_descen_get(A,X2,Y2,K,B).

/*FIXME: length CPiece*/
check_win_wrapper(Col,Winner,WinPiece,Consecutive,CPiece):-
	length(Col,CPiece),
	Consecutive = 4,
	hash(WinPiece,Winner),
	!.

check_win_wrapper(Col,Winner,WinPiece,Consecutive,CPiece):-
	nth0(CPiece,Col,Piece2),
	not(Piece2 is WinPiece),
	CPiece2 is CPiece+1,
	check_win_wrapper(Col,Winner,WinPiece,0,CPiece2).

/*FIXME: CPiece+1 bound*/
check_win_wrapper(Col,Winner,WinPiece,Consecutive,CPiece):-
	nth0(CPiece,Col,Piece2),
	Piece2 is WinPiece,
	Con2 is Consecutive+1,
	CPiece2 is CPiece+1,
	check_win_wrapper(Col,Winner,WinPiece,Consecutive2,CPiece2).

/*FIXME: Refactorizar el código???*/
check_vertical_wrapper(Board,NCol,Winner):-
	board_col(Board,Ncol,Col),
	nth0(0,Col,Piece1),
	check_win_wrapper(Col,Winner,Piece1,1,1).

check_vertical_win_wrapper(Board,NCol,Winner):-
	NCol < 6,
	Winner =\= 0,
	!.

check_vertical_win_wrapper(Board,NCol,Winner):-
	NCol = 6,
	Winner = 0,
	!.

check_vertical_win_wrapper(Board,NCol,Winner):-
	check_vertical_wrapper(Board,NCol,Winner),
	NCol2 is NCol+1,
	check_vertical_win_wrapper(Board,NCol2,Winner).

check_vertical_win(Board,Winner):-
	check_vertical_win_wrapper(Board,0,Winner).

/*Horizontal*/
check_horizontal_wrapper(Board,NCol,Winner):-
	board_fila(Board,Ncol,Col),
	nth0(0,Col,Piece1),
	check_win_wrapper(Col,Winner,Piece1,1,1).

check_horizontal_win_wrapper(Board,NCol,Winner):-
	NCol < 7,
	Winner =\= 0,
	!.

check_horizontal_win_wrapper(Board,NCol,Winner):-
	NCol = 7,
	Winner = 0,
	!.

check_horizontal_win_wrapper(Board,NCol,Winner):-
	check_horizontal_wrapper(Board,NCol,Winner),
	NCol2 is NCol+1,
	check_horizontal_win_wrapper(Board,NCol2,Winner).

check_horizontal_win(Board,Winner):-
	check_horizontal_win_wrapper(Board,0,Winner).
