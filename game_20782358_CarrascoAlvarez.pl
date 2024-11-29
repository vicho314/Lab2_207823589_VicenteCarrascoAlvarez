/*:- module(game_20782358_CarrascoAlvarez,[]).*/
:- consult(utils_20782358_CarrascoAlvarez).
:- consult(board_20782358_CarrascoAlvarez).
:- use_module(library(lists)).

/*TDA Game*/

/*Constructor*/
% Constructor TDA Game
% Dom: Player x Player X Board X int
% Rec: Game (list)
% Nota: añade, además, un historial vacío al final del TDA.
game(Player1,Player2,Board,CurrentTurn,[Board,Player1,Player2,CurrentTurn,[]]).

/*Selectores */

% Retorna el campo Board de TDA Game.
% Dom: Game
% Rec: Board
game_board([Board,_,_,_,_],Board).

% Retorna el campo Player1 de TDA Game.
% Dom: Game
% Rec: Player
game_player1([_,P1,_,_,_],P1).

% Retorna el campo Player2 de TDA Game.
% Dom: Game
% Rec: Player
game_player2([_,_,P2,_,_],P2).

% Retorna el campo CurrentTurn de TDA Game.
% Dom: Game
% Rec: int
game_cturn([_,_,_,Ct,_],Ct).

% Retorna el campo History de TDA Game.
% Dom: Game
% Rec: History (stack)
game_history([_,_,_,_,H],H).

/*Modificadores*/

% Modifica el campo Board de TDA Game.
% Dom: Game x Board
% Rec: Game
game_board_set([_,P1,P2,Ct,H],Board,[Board,P1,P2,Ct,H]).

% Modifica el campo Player1 de TDA Game.
% Dom: Game x Player
% Rec: Game
game_player1_set([Board,_,P2,Ct,H],P1,[Board,P1,P2,Ct,H]).

% Modifica el campo Player2 de TDA Game.
% Dom: Game x Player
% Rec: Game
game_player2_set([Board,P1,_,Ct,H],P2,[Board,P1,P2,Ct,H]).

% Modifica el campo CurrentTurn de TDA Game.
% Dom: Game x int
% Rec: Game
game_cturn_set([Board,P1,P2,_,H],Ct,[Board,P1,P2,Ct,H]).

% Modifica el campo History de TDA Game.
% Dom: Game x stack
% Rec: Game
game_history_set([Board,P1,P2,Ct,_],H,[Board,P1,P2,Ct,H]).

/* Funciones */

% Verifica si en el juego actual hay un empate.
% Dom: Game
% Rec: void
% Nota: Rama 1, el tablero está lleno, es un empate.
is_draw(Game):-
	game_board(Game,B),
	not(can_play(B)).

% Nota: Rama 2, los jugadores no tienen piezas restantes, es un empate.
is_draw(Game):-
	game_player1(Game,P1),
	game_player2(Game,P2),
	player_no_pieces(P1),
	player_no_pieces(P2).

% Verifica si en el juego actual hay un ganador.
% Dom: Game
% Rec: void
% Nota: No retorna el ganador (ver RF).
is_win(Game):-
	game_board(Game,B),
	who_is_winner(B,W),
	W > 0.

% Verifica si en el juego actual a terminado.
% Dom: Game
% Rec: void
% Nota: Rama 1, el juego terminó en empate o con ganador.
is_end(Game):-
	is_draw(Game);
	is_win(Game).

% Nota: Rama 1, el juego ya terminó, porque CurrentTurn ya es -1.
is_end(Game):-
	game_cturn(Game,Ct),
	Ct = -1.

/* 
 * Las preguntas causaron la caída de los ángeles.
*/
/* FIXME: R E V I S A R  el documento de RF, probablemente cambien 
la definición de este predicado.*/
/* Asume que CurrentTurn es End (-1).*/
% Actualiza las estadísticas de OldPlayer, si ha ganado, empatado, o perdido,
% correspondiente al caso. Se hace una búsqueda con el jugador actual,
% para determinar qué tipo de actualización se debe hacer.
% Dom: Game x player
% Rec: Player
% Nota: Caso 1, el jugador ganó.
update_stats(Game,OldPlayer,NewPlayer):-
	% is_end(Game),
	game_board(Game,Board),
	who_is_winner(Board,Id1),
	Id1 > 0,
	/*Mala idea, pero en TDA Board no tenemos Player.*/
	player_id(OldPlayer,Id1),
	player_update_stats(OldPlayer,1,NewPlayer).

% Nota: Caso 2, el jugador perdió.
update_stats(Game,OldPlayer,NewPlayer):-
	% is_end(Game),
	game_board(Game,Board),
	who_is_winner(Board,Id1),
	who_is_loser(Id1,Id2),
	Id2 > 0,
	player_id(OldPlayer,Id2),
	player_update_stats(OldPlayer,0,NewPlayer).

% Nota: Caso 3, el jugador empató.
update_stats(Game,OldPlayer,NewPlayer):-
	% is_end(Game),
	is_draw(Game),
	player_update_stats(OldPlayer,2,NewPlayer).

% Muestra el tablero del juego actual en pantalla, y lo retorna.
% Dom: Game
% Rec: Board
game_get_board(Game,Board):-
	game_board(Game,Board),
	display_board(Board).

/* Mala idea, los jugadores podrían ir indexados en una lista propia.*/
% Retorna el jugador actual, usando el valor de CurrentTurn.
% Dom: Game
% Rec: Player
% Nota: Caso 1, el jugador es el player1.
get_current_player(Game,P):-
	game_cturn(Game,Id),
	Id >= 0,
	player_id(P,Id),
	game_player1(Game,P).

% Nota: Caso 2, el jugador es el player2.
get_current_player(Game,P):-
	game_cturn(Game,Id),
	Id >= 0,
	player_id(P,Id),
	game_player2(Game,P).

% Actualiza los datos del jugador que tiene el mismo Id que NewP.
% Dom: Game x Player
% Rec: Game
% Nota: Caso 1, Player1.
game_update_player(Game,NewP,NewG):-
	game_player1(Game,OldP),
	player_id(OldP,Id),
	player_id(NewP,Id),
	game_player1_set(Game,NewP,NewG).

% Nota: Caso 2, Player2.
game_update_player(Game,NewP,NewG):-
	game_player2(Game,OldP),
	player_id(OldP,Id),
	player_id(NewP,Id),
	game_player2_set(Game,NewP,NewG).

% Añade un movimiento al historial, en formato Col|Pz.
% Dom: Game x int x string
% Rec: Game
% Nota: History es un stack.
game_history_add(Game,Col,Pz,NewG):-
	game_history(Game,H),
	stack_push(H,Col|Pz,H2),
	game_history_set(Game,H2,NewG).

% "Voltea" el turno actual, es decir, pasa el turno al valor
% siguiente que le corresponde.
% Dom: Game
% Rec: Game
% Nota: Caso borde, CurrentTurn pasa a 2.
game_flip_turn(Game,NewGame):-
	game_cturn(Game,Ct),
	Ct is 1,
	NewCt is 2,
	game_cturn_set(Game,NewCt,NewGame).

% Nota: Caso borde, CurrentTurn pasa a 1.
game_flip_turn(Game,NewGame):-
	game_cturn(Game,Ct),
	Ct is 2,
	NewCt is 1,
	game_cturn_set(Game,NewCt,NewGame).

% Nota: Caso borde, el juego ya terminó, el turno no pasa.
% ¡No se usó is_end() debido a las ramas! 
game_flip_turn(Game,Game):-
	game_cturn(Game,Ct),
	Ct = -1.


/* 'Debiste haber apuntado a la cabeza.' */
% Función auxiliar para actualizar las estadísticas de los jugadores
% al finalizar un juego.
% Dom: Game
% Rec: Game
end_game_stats(Game,NewGame):-
	game_player1(Game,P1),
        game_player2(Game,P2),
        update_stats(Game,P1,NP1),
        update_stats(Game,P2,NP2),
        game_update_player(Game,NP1,G1),
        game_update_player(G1,NP2,NewGame).

% Declara un juego como terminado, es decir, CurrentTurn = -1.
% Dom: Game
% Rec: Game
end_game(Game,NewGame):-
	game_cturn_set(Game,-1,NewGame).

/*verificar si hay win o empate*/
% Función que se encarga de hacer las jugadas de un jugador en el tablero.
% Verifica si el jugador puede jugar en el turno actual, si el juego queda en
% empate o condición de victoria, actualizando los datos en el proceso.
% NOTA: No declara un juego como terminado (ver RF).
% Dom: Game x Player x int
% Rec: Game
% Nota: Caso borde, el juego está en condición de termino, actualizar datos.
player_play(Game,_,-1,NewGame):-
	(is_draw(Game);is_win(Game)),
	end_game_stats(Game,NewGame).

/*Nota: Si no termina, sigue el juego.*/ 
player_play(Game,_,-1,Game):-
	not(is_win(Game)),
	not(is_draw(Game)),
	!.

% Nota: Caso general, verifica el jugador, y pone la pieza en la columna
% en la posición NCol. Actualiza el historial y cambia el turno.
player_play(Game,Player,NCol,NewGame):-
	NCol >= 0,
	get_current_player(Game,PlayerTest),
	player_id(Player,Id),
	player_id(PlayerTest,Id),
	not(player_no_pieces(Player)),
	game_get_board(Game,B1),
	can_play_col(B1,NCol),
	player_color(Player,Color),
	piece(Color,Pz),
	play_piece(B1,NCol,Pz,B2),
	player_update_pieces(Player,-1,NewP),
	game_board_set(Game,B2,G2),
	game_update_player(G2,NewP,G3),
	game_history_add(G3,NCol,Pz,G4),
	/*verificar ganador o empate y actualizar*/
	player_play(G4,Player,-1,G5),
	game_flip_turn(G5,NewGame),
	!.
