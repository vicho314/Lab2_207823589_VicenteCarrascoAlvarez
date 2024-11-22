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

is_win(Game):-
	game_board(Game,B),
	who_is_winner(B,W),
	W > 0.

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

game_update_player(Game,NewP,NewG):-
	game_player1(Game,OldP),
	player_id(OldP,Id),
	player_id(NewP,Id),
	game_player1_set(Game,NewP,NewG).

game_update_player(Game,NewP,NewG):-
	game_player2(Game,OldP),
	player_id(OldP,Id),
	player_id(NewP,Id),
	game_player2_set(Game,NewP,NewG).

game_history_add(Game,Col,Pz,NewG):-
	game_history(Game,H),
	stack_push(H,Col|Pz,H2),
	game_history_set(Game,H2,NewG).

/*verificar si hay win o empate, y terminar juego*/
player_play(Game,_,-1,NewGame):-
	is_draw(Game),
	game_player1(Game,P1),
	game_player1(Game,P2),
	update_stats(Game,P1,NP1),
	update_stats(Game,P2,NP2),
	game_update_player(Game,NP1,G2),
	game_update_player(G2,NP2,G3),
	end_game(G3,NewGame).

player_play(Game,_,-1,NewGame):-
	is_win(Game),
	game_player1(Game,P1),
	game_player1(Game,P2),
	update_stats(Game,P1,NP1),
	update_stats(Game,P2,NP2),
	game_update_player(Game,NP1,G2),
	game_update_player(G2,NP2,G3),
	end_game(G3,NewGame).

/*Si no termina, sigue el juego.*/
player_play(Game,_,-1,Game):-
	not(is_win(Game)),
	not(is_draw(Game)).
	
player_play(Game,Player,NCol,NewGame):-
	get_current_player(Game,Player),
	not(player_no_pieces(Player)),
	game_board(Game,B1),
	can_play_col(B1,NCol),
	player_color(Player,Color),
	piece(Color,Pz),
	play_piece(B1,NCol,Pz,B2),
	player_update_pieces(Player,-1,NewP),
	game_board_set(Game,B2,G2),
	game_update_player(G2,NewP,G3),
	game_flip_turn(G3,G4),
	game_history_add(G4,Col,Pz,G5),
	/*verificar ganador o empate y actualizar*/
	player_play(G5,Player,-1,NewGame).
