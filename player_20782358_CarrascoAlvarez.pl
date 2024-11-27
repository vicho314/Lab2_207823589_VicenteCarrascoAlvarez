:- module(player_20782358_CarrascoAlvarez,[]).
/* TDA Player */

/* Constructor */
/* ¿Porqué no dejan usar functores?*/
player(Id,Name,Color,Wins,Losses,Draws,Rem,[Id,Name,Color,Wins,Losses,Draws,Rem]).

/* Selectores */
player_id([I,_,_,_,_,_,_],I).
player_name([_,I,_,_,_,_,_],I).
player_color([_,_,I,_,_,_,_],I).
player_wins([_,_,_,I,_,_,_],I).
player_losses([_,_,_,_,I,_,_],I).
player_draws([_,_,_,_,_,I,_],I).
player_rem([_,_,_,_,_,_,I],I).

/* Modificadores */
player_id_set([_,A2,A3,A4,A5,A6,A7],I,[I,A2,A3,A4,A5,A6,A7]).
player_name_set([A1,_,A3,A4,A5,A6,A7],I,[A1,I,A3,A4,A5,A6,A7]).
player_color_set([A1,A2,_,A4,A5,A6,A7],I,[A1,A2,I,A4,A5,A6,A7]).
player_wins_set([A1,A2,A3,_,A5,A6,A7],I,[A1,A2,A3,I,A5,A6,A7]).
player_losses_set([A1,A2,A3,A4,_,A6,A7],I,[A1,A2,A3,A4,I,A6,A7]).
player_draws_set([A1,A2,A3,A4,A5,_,A7],I,[A1,A2,A3,A4,A5,I,A7]).
player_rem_set([A1,A2,A3,A4,A5,A6,_],I,[A1,A2,A3,A4,A5,A6,I]).

/* Funciones */
player_no_pieces(P):-
	player_rem(P,Rem),
	Rem = 0.

/*0 = Loss, 1 = Win, 2 = Draw*/
player_update_stats(P,0,NewP):-
	player_losses(P,L),
	L2 is L+1,
	player_losses_set(P,L2,NewP).
	

player_update_stats(P,1,NewP):-
	player_wins(P,L),
	L2 is L+1,
	player_wins_set(P,L2,NewP).


player_update_stats(P,2,NewP):-
	player_draws(P,L),
	L2 is L+1,
	player_draws_set(P,L2,NewP).

player_update_pieces(P,Add,NewP):-
	player_rem(P,Pz),
	Pz2 is Pz+Add,
	player_rem_set(P,Pz2,NewP).
