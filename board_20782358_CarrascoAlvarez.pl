/*:- module(board_20782358_CarrascoAlvarez,[]).*/
:- use_module(library(apply)). /* filter, map, foldl*/
:- consult(utils_20782358_CarrascoAlvarez).
:- use_module(library(lists)).

% Verifica si A no es 0. Función auxiliar.
% Dom: int
% Rec: void
non_zero(A):-
	not(A = 0).

% Quita los 0s de una lista. Función auxiliar para colocar fichas.
% Dom: list
% Rec: list 
non_zero_list(A,B):-
	include(non_zero,A,B).

% Llena una lista con 0s hasta que sea de tamaño Len. 
% Función auxiliar para colocar fichas.
% Dom: list x int
% Rec: list
% Nota: Caso borde, la lista final tiene el largo indicado. 
zero_fill(L2,Len,L2):-
	length(L2,K),
	K is Len,
	!.

% Nota: Caso general, la lista final aún no tiene el largo indicado.
zero_fill(L,Len,L2):-
	length(L,K),
	K < Len,
	append(L,[0],L1),
	zero_fill(L1,Len,L2).

% Llena una lista con V hasta que sea de tamaño Len. 
% Función auxiliar para colocar fichas.
% Dom: list x int x atom
% Rec: list
% Nota: Caso borde, la lista final tiene el largo indicado. 
value_fill(L2,Len,_,L2):-
	length(L2,K),
	K is Len,
	!.
	
% Nota: Caso general, la lista final no tiene el largo indicado. 
value_fill(L,Len,V,L2):-
	length(L,K),
	K < Len,
	append(L,[V],L1),
	value_fill(L1,Len,V,L2).

/* TDA piece */
% Constructor TDA Piece
% Dom: string
% Rec: Piece (list)
piece(Color,[Color]).

% Hace un "hash" de las piezas, para saber quién es el ganador
% de una jugada. Las fichas nulas son 0.
% Dom: Piece (list)
% Rec: int
/*Mala idea, blame RF.*/
hash_piece(["red"],1).
hash_piece(["yellow"],2).
hash_piece(0,0).

% Aplica un or lógico al resultado de hash_piece, es decir,
% retorna 0 si no hay ganador, y 1 o 2 en caso contrario.
% Nota: El caso en que ambos jugadores ganan está indefinido.
% Dom: int x int
% Rec: int
hash_or(0,0,0).
hash_or(A,B,C):-
	((A > 0,
	C = A);
	(B > 0,
	C = B)).

/* TDA board */
% Revisa si una columna está vacía. Función auxiliar.
% Dom: list
% Rec: void
col_length_empty(L):-
	length(L,0).

% Revisa si una columna NO está LLENA. Función auxiliar.
% Dom: list
% Rec: void
col_length_notfull(L):-
	length(L,X),
	X < 6 .

/* Constructor */

/*
board(Board):-
	length(Board1,7),
	include(col_length_empty,Board1,Board2).
*/
% Constructor TDA Board. Crea una lista de listas, de dimensión 7x6.
% Para ello, llena el tablero de fichas nulas (0).
% Dom: void
% Rec: Board (list)
board(Board):-
	zero_fill([],6,EmptyCol),
	value_fill([],7,EmptyCol,Board).

/* Selector */
% Retorna la columna en la posición N, considerando que 
% la primera columna está en la posición 0.
% Dom: Board x int
% Rec: Col (list)
board_col(Board,N,Col):-
	nth0(N,Board,Col).

/*fixme: foldl o scanl*/
% Retorna la fila en la posición N, considerando que 
% la primera fila está en la posición 0.
% Nota: Se usa la transpuesta de la matriz original.
% Dom: Board x int
% Rec: Fila (list)
board_fila(Board,N,Fila):-
	transpose(Board,B2),
	board_col(B2,N,Fila).

% Retorna la ficha en la posición (X,Y), considerando que 
% la primera ficha está en la posición (0,0).
% Dom: Board x int x int
% Rec: V (Piece)
board_getxy(Board,X,Y,V):-
	nth0(X,Board,Col),
	nth0(Y,Col,V).		

% Verifica si el tablero no está lleno, es decir, si aún se pueden
% hacer jugadas en él.
% Nota: maplist e include filtran las listas por tamaño. Si aún 
% quedan espacios, significa que el tablero aún no está lleno.
% Dom: Board
% Rec: void
can_play(Board):-
	maplist(non_zero_list,Board,Board1),
	include(col_length_notfull,Board1,Board2),
	length(Board2,Notfullcols),
	Notfullcols > 0.

% Similar a can_play, pero revisa sólo la columna en la posición NCol.
% Dom: Board x int
% Rec: void
can_play_col(Board,NCol):-
	maplist(non_zero_list,Board,Board1),
	nth0(NCol,Board1,C),
	length(C,Notfullcol),
	Notfullcol < 6.

% Coloca una ficha en una columna, es decir, efectúa una jugada.
% Dom: Board x int x Piece (list)
% Rec: Board
play_piece(Board,Col,Piece,NBoard):-
	write("Jugada en Columna:"),
	writeln(Col),
	board_col(Board,Col,C),
	non_zero_list(C,C2),
	append(C2,[Piece],NewC),
	zero_fill(NewC,6,NewC2),
	write_list(Board,Col,NewC2,NBoard),
	!.

% Revisa si la posición (X,Y) está DENTRO de límites.
% Dom: int x int
% Rec: void
in_bounds(X,Y):-
	X < 7,
	X >= 0,
	Y < 6,
	Y >= 0.

% Retorna la diagonal ascendente partiendo desde (X,Y), 
% contando las fichas en el proceso.
% Dom: Board x int x int x Len (int) 
% Rec: (list)
% Nota: Caso borde, terminar si ya estamos fuera de límites o 
% si la diagonal es muy pequeña como para evaluar un resultado.
diag_ascen_get(_,X,Y,_,B):-
	not(in_bounds(X,Y)),
	length(B,K),
	K > 3,
	K =< 6,
	!.

% Nota: Caso general, recolectar piezas recursivamente mientras esté 
% dentro de límites.
diag_ascen_get(A,X,Y,C,B):-
        in_bounds(X,Y),
        board_getxy(A,X,Y,V0),
        nth0(C,B,V0),
        K is C+1,
        X2 is X+1,
        Y2 is Y+1,
        diag_ascen_get(A,X2,Y2,K,B).

% Retorna la diagonal descendente partiendo desde (X,Y), 
% contando las fichas en el proceso.
% Dom: Board x int x int x Len (int) 
% Rec: (list)
% Nota: Caso borde, terminar si ya estamos fuera de límites o 
% si la diagonal es muy pequeña como para evaluar un resultado.
diag_descen_get(_,X,Y,_,B):-
	not(in_bounds(X,Y)),
	length(B,K),
	K > 3,
	K =< 6,
	!.

% Nota: Caso general, recolectar piezas recursivamente mientras esté 
% dentro de límites.
diag_descen_get(A,X,Y,C,B):-
        in_bounds(X,Y),
        board_getxy(A,X,Y,V0),
        nth0(C,B,V0),
        K is C+1,
        X2 is X-1,
        Y2 is Y-1,
        diag_descen_get(A,X2,Y2,K,B).

% Función auxiliar que se encarga de decidir un ganador, contando si hay
% piezas consecutivas, actualizando la pieza actual a comparar si encuentra
% una nueva, reseteando el contadores en dicho caso.
% Nota: Todos los casos (col, fila, diag) se pueden 
% reducir a una columna de piezas (Col).
% Dom: list  x (Piece) x int x int
% Rec: Winner (int)
% Nota: caso borde, no hay ganador, la pieza actual es 0.
check_win_wrapper(Col,Winner,_,Consecutive,CPiece):-
	length(Col,CPiece),
	Consecutive < 4,
	hash_piece(0,Winner),
	!.

/*FIXME: length CPiece*/
% Nota: caso borde, no hay ganador, la pieza actual es WinPiece.
check_win_wrapper(_,Winner,WinPiece,Consecutive,_):-
	/*length(Col,CPiece),*/
	Consecutive = 4,
	hash_piece(WinPiece,Winner),
	!.

% Nota: rama general, la pieza actual NO es igual a la anterior,
% sigue con la recursión reseteando el contador Consecutive.
check_win_wrapper(Col,Winner,WinPiece,_,CPiece):-
	nth0(CPiece,Col,Piece2),
	not(Piece2 = WinPiece),
	CPiece2 is CPiece+1,
	check_win_wrapper(Col,Winner,WinPiece,0,CPiece2).

/*FIXME: CPiece+1 bound*/
% Nota: rama general, la pieza actual SÍ es igual a la anterior,
% sigue con la recursión aumentando el contador Consecutive.
check_win_wrapper(Col,Winner,WinPiece,Consecutive,CPiece):-
	nth0(CPiece,Col,Piece2),
	Piece2 = WinPiece,
	Consecutive2 is Consecutive+1,
	CPiece2 is CPiece+1,
	check_win_wrapper(Col,Winner,WinPiece,Consecutive2,CPiece2).

/*FIXME: Refactorizar el código???*/
% Función auxiliar (wrapper) para verificar un ganador vertical.
% Revisa las columnas recursivamente, terminando si encuentra un ganador.
% Dom: Board x int
% Rec: int
% Nota: caso borde, hay un ganador, termina la búsqueda.
check_vertical_wrapper(Board,NCol,Winner):-
	board_col(Board,NCol,Col),
	nth0(0,Col,Piece1),
	check_win_wrapper(Col,Winner,Piece1,1,1),
	not(Winner is 0),
	!.
	
% Nota: caso general, todavía no hay un ganador, sigue con la búsqueda.
check_vertical_wrapper(Board,NCol,Winner):-
	board_col(Board,NCol,Col),
	nth0(0,Col,Piece1),
	check_win_wrapper(Col,Winner1,Piece1,1,1),
	Winner1 is 0,
	NCol2 is NCol+1,
	check_vertical_wrapper(Board,NCol2,Winner).

% Nota: caso borde, no hay ganador, ya se revisaron las 7 columnas.
check_vertical_wrapper(_,NCol,Winner):-
	NCol = 7,
	Winner is 0.

% Función para verificar un ganador vertical.
% Revisa las columnas recursivamente, terminando si encuentra un ganador,
% usando el wrapper correspondiente.
% Dom: Board
% Rec: int
check_vertical_win(Board,Winner):-
	check_vertical_wrapper(Board,0,Winner).

/*Horizontal*/
% Función auxiliar (wrapper) para verificar un ganador horizontal.
% Revisa las filas recursivamente, terminando si encuentra un ganador.
% Dom: Board x int
% Rec: int
% Nota: caso borde, hay un ganador, termina la búsqueda.
check_horizontal_wrapper(Board,NCol,Winner):-
	board_fila(Board,NCol,Col),
	nth0(0,Col,Piece1),
	check_win_wrapper(Col,Winner,Piece1,1,1),
	not(Winner is 0),
	!.

% Nota: caso general, todavía no hay un ganador, sigue con la búsqueda.
check_horizontal_wrapper(Board,NCol,Winner):-
	board_fila(Board,NCol,Col),
	nth0(0,Col,Piece1),
	check_win_wrapper(Col,Winner1,Piece1,1,1),
	Winner1 is 0,
	NCol2 is NCol+1,
	check_horizontal_wrapper(Board,NCol2,Winner).


% Nota: caso borde, no hay ganador, ya se revisaron las 6 filas.
check_horizontal_wrapper(_,NCol,Winner):-
	NCol = 6,
	Winner is 0.

% Función para verificar un ganador horizontal.
% Revisa las filas recursivamente, terminando si encuentra un ganador,
% usando el wrapper correspondiente.
% Dom: Board
% Rec: int
check_horizontal_win(Board,Winner):-
	check_horizontal_wrapper(Board,0,Winner).

/*Diagonal ascendente*/
% Función auxiliar (wrapper) para verificar un ganador diagonal vertical.
% Revisa las diagonales ascendentes mediante una lista de puntos predefinida,
% terminando si encuentra un ganador.
% Nota: No es necesario revisar todas las diagonales.
% Dom: Board x [[X,Y],...] (list) x int
% Rec: int
% Nota: caso borde, hay un ganador, termina la búsqueda.
check_ascen_wrapper(Board,Points,Index,Winner):-
	nth0(Index,Points,[X,Y]),
	diag_ascen_get(Board,X,Y,0,Col),
	nth0(0,Col,Piece1),
	check_win_wrapper(Col,Winner,Piece1,1,1),
	not(Winner is 0),
	!.

% Nota: caso general, todavía no hay un ganador, sigue con la búsqueda.
check_ascen_wrapper(Board,Points,Index,Winner):-
	nth0(Index,Points,[X,Y]),
	diag_ascen_get(Board,X,Y,0,Col),
	nth0(0,Col,Piece1),
	check_win_wrapper(Col,Winner1,Piece1,1,1),
	Winner1 is 0,
	Index2 is Index+1,
	check_ascen_wrapper(Board,Points,Index2,Winner).

% Nota: caso borde, no hay ganador, ya se revisaron los puntos.
check_ascen_wrapper(_,Points,Index,Winner):-
	length(Points,K),
	Index = K,
	Winner is 0.

% Función para verificar un ganador diagonal vertical.
% Revisa las diagonales ascendentes recursivamente, terminando 
% si encuentra un ganador, usando el wrapper correspondiente.
% Dom: Board
% Rec: int
% Nota: P = lista de puntos estática para búsqueda.
check_ascen_win(Board,Winner):-
	(P = [[0,0],[1,0],[2,0],[3,0],[0,1],[0,2]]),
	check_ascen_wrapper(Board,P,0,Winner).


/*Diagonal descendente*/
% Función auxiliar (wrapper) para verificar un ganador diagonal descendente.
% Revisa las diagonales descendentes mediante una lista de puntos predefinida,
% terminando si encuentra un ganador.
% Nota: No es necesario revisar todas las diagonales.
% Dom: Board x [[X,Y],...] (list) x int
% Rec: int
% Nota: caso borde, hay un ganador, termina la búsqueda.
check_descen_wrapper(Board,Points,Index,Winner):-
	nth0(Index,Points,[X,Y]),
	diag_descen_get(Board,X,Y,0,Col),
	nth0(0,Col,Piece1),
	check_win_wrapper(Col,Winner,Piece1,1,1),
	not(Winner is 0),
	!.

% Nota: caso general, todavía no hay un ganador, sigue con la búsqueda.
check_descen_wrapper(Board,Points,Index,Winner):-
	nth0(Index,Points,[X,Y]),
	diag_descen_get(Board,X,Y,0,Col),
	nth0(0,Col,Piece1),
	check_win_wrapper(Col,Winner1,Piece1,1,1),
	Winner1 is 0,
	Index2 is Index+1,
	check_descen_wrapper(Board,Points,Index2,Winner).

% Nota: caso borde, no hay ganador, ya se revisaron los puntos.
check_descen_wrapper(_,Points,Index,Winner):-
	length(Points,K),
	Index = K,
	Winner is 0.

% Función para verificar un ganador diagonal vertical.
% Revisa las diagonales ascendentes recursivamente, terminando
% si encuentra un ganador, usando el wrapper correspondiente.
% Dom: Board
% Rec: int
% Nota: P = lista de puntos estática para búsqueda.
check_descen_win(Board,Winner):-
	(P = [[0,5],[1,5],[2,5],[3,5],[0,4],[0,3]]),
	check_descen_wrapper(Board,P,0,Winner).

% Función que verifica si hay un ganador diagonal, revisando
% las diagonales ascendentes y descendentes.
% Dom: Board
% Rec: int
check_diagonal_win(Board,Winner):-
	check_ascen_win(Board,Winner1),
	check_descen_win(Board,Winner2),
	hash_or(Winner1,Winner2,Winner).

% Función que verifica si hay un ganador, revisando
% las filas, columnas y diagonales.
% Dom: Board
% Rec: int
who_is_winner(Board,Winner):-
	check_vertical_win(Board,W1),
	check_horizontal_win(Board,W2),
	check_diagonal_win(Board,W3),
	hash_or(W1,W2,W4),
	hash_or(W3,W4,Winner).

% Función que determina el perdedor, dado el ganador.
% Dom: Winner (int)
% Rec: Loser (int)
who_is_loser(0,0).
who_is_loser(1,2).
who_is_loser(2,1).

% Muestra el tablero en la salida estándar, línea por línea.
% Nota: maplist.
% Dom: Board
% Rec: void (salida de texto en pantalla)
display_board(Board):-
	maplist(writeln,Board),
	!.
