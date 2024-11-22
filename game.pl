:- consult(utils).
:- consult(board).
:- use_module(library(lists)).

/*TDA Game*/

/*Constructor*/
game(Board,Player1,Player2,CurrentTurn,[Board,Player1,Player2,CurrentTurn,[]]).

/*Selectores */
game_board([Board,_,_,_,_],Board).
game_player1([_,P1,_,_,_],P1).
game_player2([_,_,P2,_,_],P2).
game_cturn([_,_,_,Ct,_],Ct).
game_history([_,_,_,_,H],H).

/*Modificadores*/
game_board_set([_,P1,P2,Ct,H],Board,[Board,P1,P2,Ct,H]).
game_player1_set([Board,_,P2,Ct,H],P1,[Board,P1,P2,Ct,H]).
game_player2_set([Board,P1,_,Ct,H],P2,[Board,P1,P2,Ct,H]).
game_cturn_set([Board,P1,P2,_,H],Ct,[Board,P1,P2,Ct,H]).
game_history_set([Board,P1,P2,Ct,_],H,[Board,P1,P2,Ct,H]).

/* Funciones */
is_draw(Game):-
	game_board_get(Game,B),
	not(can_play(B)).

is_draw(Game):-
	game_player1_get(Game,P1),
	game_player2_get(Game,P2),
	player_no_pieces(P1),
	player_no_pieces(P2).

is_end(Game):-
	game_cturn(Game,Ct),
	Ct = -1.

/* 
 * Las preguntas causaron la caída de los ángeles.
*/
/* FIXME: R E V I S A R  el documento de RF, probablemente cambien 
la definición de este predicado.*/
/* Asume que CurrentTurn es End (-1).*/
update_stats(Game,OldPlayer,NewPlayer):-
	is_end(Game),
	game_board(Game,Board),
	who_is_winner(Board,Id1),
	Id1 > 0,
	/*Mala idea, pero en TDA Board no tenemos Player.*/
	player_id(OldPlayer,Id1),
	player_update_stats(OldPlayer,1,NewPlayer).

update_stats(Game,OldPlayer,NewPlayer):-
	is_end(Game),
	game_board(Game,Board),
	who_is_winner(Board,Id1),
	who_is_loser(Id1,Id2),
	Id2 > 0,
	player_id(OldPlayer,Id2),
	player_update_stats(OldPlayer,0,NewPlayer).

update_stats(Game,OldPlayer,NewPlayer):-
	is_end(Game),
	is_draw(Game),
	player_update_stats(OldPlayer,2,NewPlayer).

get_board(Game,Board):-
	game_board(Game,Board),
	display_board(Board).

/* 'Debiste haber apuntado a la cabeza.' */
end_game(Game,Game2):-
	game_cturn_set(Game,-1,Game2).

get_current_player(Game,P):-
	game_cturn(Game,Id),
	Id >= 0,
	game_player1(P),
	player_id(P,Id).

get_current_player(Game,P):-
	game_cturn(Game,Id),
	Id >= 0,
	game_player2(P),
	player_id(P,Id).
