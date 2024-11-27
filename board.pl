:- module(board_20782358_CarrascoAlvarez,[]).
:- use_module(library(apply)). /* filter, map, foldl*/
:- use_module(utils_20782358_CarrascoAlvarez).
:- use_module(library(lists)).

non_zero(A):-
	not(A = 0).

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

hash_or(0,0,0).
hash_or(A,B,C):-
	((A > 0,
	C = A);
	(B > 0,
	C = B)).

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
	maplist(non_zero_list,Board,Board1),
	include(col_length_notfull,Board1,Board2),
	length(Board2,Notfullcols),
	Notfullcols > 0.

can_play_col(Board,NCol):-
	maplist(non_zero_list,Board,Board1),
	nth0(NCol,Board1,C),
	length(C,Notfullcol),
	Notfullcol < 6.

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
check_win_wrapper(_,Winner,WinPiece,Consecutive,_):-
	/*length(Col,CPiece),*/
	Consecutive = 4,
	hash_piece(WinPiece,Winner),
	!.

check_win_wrapper(Col,Winner,WinPiece,_,CPiece):-
	nth0(CPiece,Col,Piece2),
	not(Piece2 = WinPiece),
	CPiece2 is CPiece+1,
	check_win_wrapper(Col,Winner,WinPiece,0,CPiece2).

/*FIXME: CPiece+1 bound*/
check_win_wrapper(Col,Winner,WinPiece,Consecutive,CPiece):-
	nth0(CPiece,Col,Piece2),
	Piece2 = WinPiece,
	Consecutive2 is Consecutive+1,
	CPiece2 is CPiece+1,
	check_win_wrapper(Col,Winner,WinPiece,Consecutive2,CPiece2).

/*FIXME: Refactorizar el código???*/
check_vertical_wrapper(Board,NCol,Winner):-
	board_col(Board,NCol,Col),
	nth0(0,Col,Piece1),
	check_win_wrapper(Col,Winner,Piece1,1,1),
	not(Winner is 0),
	!.

check_vertical_wrapper(Board,NCol,Winner):-
	board_col(Board,NCol,Col),
	nth0(0,Col,Piece1),
	check_win_wrapper(Col,Winner1,Piece1,1,1),
	Winner1 is 0,
	NCol2 is NCol+1,
	check_vertical_wrapper(Board,NCol2,Winner).

check_vertical_wrapper(_,NCol,Winner):-
	NCol = 6,
	Winner is 0.

check_vertical_win(Board,Winner):-
	check_vertical_wrapper(Board,0,Winner).

/*Horizontal*/
check_horizontal_wrapper(Board,NCol,Winner):-
	board_fila(Board,NCol,Col),
	nth0(0,Col,Piece1),
	check_win_wrapper(Col,Winner,Piece1,1,1),
	not(Winner is 0),
	!.

check_horizontal_wrapper(Board,NCol,Winner):-
	board_fila(Board,NCol,Col),
	nth0(0,Col,Piece1),
	check_win_wrapper(Col,Winner1,Piece1,1,1),
	Winner1 is 0,
	NCol2 is NCol+1,
	check_horizontal_wrapper(Board,NCol2,Winner).

check_horizontal_wrapper(_,NCol,Winner):-
	NCol = 7,
	Winner is 0.

check_horizontal_win(Board,Winner):-
	check_horizontal_wrapper(Board,0,Winner).

/*Diagonal ascendente*/
check_ascen_wrapper(Board,Points,Index,Winner):-
	nth0(Index,Points,[X,Y]),
	diag_ascen_get(Board,X,Y,0,Col),
	nth0(0,Col,Piece1),
	check_win_wrapper(Col,Winner,Piece1,1,1),
	not(Winner is 0),
	!.

check_ascen_wrapper(Board,Points,Index,Winner):-
	nth0(Index,Points,[X,Y]),
	diag_ascen_get(Board,X,Y,0,Col),
	nth0(0,Col,Piece1),
	check_win_wrapper(Col,Winner1,Piece1,1,1),
	Winner1 is 0,
	Index2 is Index+1,
	check_ascen_wrapper(Board,Points,Index2,Winner).

check_ascen_wrapper(_,Points,Index,Winner):-
	length(Points,K),
	Index = K,
	Winner is 0.

check_ascen_win(Board,Winner):-
	(P = [[0,0],[1,0],[2,0],[3,0],[0,1],[0,2]]),
	check_ascen_wrapper(Board,P,0,Winner).


/*Diagonal descendente*/
check_descen_wrapper(Board,Points,Index,Winner):-
	nth0(Index,Points,[X,Y]),
	diag_descen_get(Board,X,Y,0,Col),
	nth0(0,Col,Piece1),
	check_win_wrapper(Col,Winner,Piece1,1,1),
	not(Winner is 0),
	!.

check_descen_wrapper(Board,Points,Index,Winner):-
	nth0(Index,Points,[X,Y]),
	diag_descen_get(Board,X,Y,0,Col),
	nth0(0,Col,Piece1),
	check_win_wrapper(Col,Winner1,Piece1,1,1),
	Winner1 is 0,
	Index2 is Index+1,
	check_descen_wrapper(Board,Points,Index2,Winner).

check_descen_wrapper(_,Points,Index,Winner):-
	length(Points,K),
	Index = K,
	Winner is 0.

check_descen_win(Board,Winner):-
	(P = [[0,5],[1,5],[2,5],[3,5],[0,4],[0,3]]),
	check_descen_wrapper(Board,P,0,Winner).

check_diagonal_win(Board,Winner):-
	check_ascen_win(Board,Winner1),
	check_descen_win(Board,Winner2),
	hash_or(Winner1,Winner2,Winner).

who_is_winner(Board,Winner):-
	check_vertical_win(Board,W1),
	check_horizontal_win(Board,W2),
	check_diagonal_win(Board,W3),
	hash_or(W1,W2,W4),
	hash_or(W3,W4,Winner).

who_is_loser(0,0).
who_is_loser(1,2).
who_is_loser(2,1).

display_board(Board):-
	maplist(writeln,Board).
