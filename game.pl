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

