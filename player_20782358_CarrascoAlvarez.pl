/*:- module(player_20782358_CarrascoAlvarez,[]).*/
/* TDA Player */

/* Constructor */
/* ¿Porqué no dejan usar functores?*/
% Constructor TDA Player.
% Dom: int x string x string x int x int x int x int
% Rec: Player (list)
player(Id,Name,Color,Wins,Losses,Draws,Rem,[Id,Name,Color,Wins,Losses,Draws,Rem]).

/* Selectores */
% Retorna el campo Id de Player.
% Dom: Player
% Rec: int
player_id([I,_,_,_,_,_,_],I).

% Retorna el campo Name de Player.
% Dom: Player
% Rec: string
player_name([_,I,_,_,_,_,_],I).

% Retorna el campo Color de Player.
% Dom: Player
% Rec: string
player_color([_,_,I,_,_,_,_],I).

% Retorna el campo Wins de Player.
% Dom: Player
% Rec: int
player_wins([_,_,_,I,_,_,_],I).

% Retorna el campo Losses de Player.
% Dom: Player
% Rec: int
player_losses([_,_,_,_,I,_,_],I).

% Retorna el campo Draws de Player.
% Dom: Player
% Rec: int
player_draws([_,_,_,_,_,I,_],I).

% Retorna el campo RemainingPieces de Player.
% Dom: Player
% Rec: int
player_rem([_,_,_,_,_,_,I],I).

/* Modificadores */

% Modifica el campo Id de Player.
% Dom: Player x int
% Rec: Player
player_id_set([_,A2,A3,A4,A5,A6,A7],I,[I,A2,A3,A4,A5,A6,A7]).

% Modifica el campo Name de Player.
% Dom: Player x string
% Rec: Player
player_name_set([A1,_,A3,A4,A5,A6,A7],I,[A1,I,A3,A4,A5,A6,A7]).

% Modifica el campo Color de Player.
% Dom: Player x int
% Rec: Player
player_color_set([A1,A2,_,A4,A5,A6,A7],I,[A1,A2,I,A4,A5,A6,A7]).

% Modifica el campo Wins de Player.
% Dom: Player x int
% Rec: Player
player_wins_set([A1,A2,A3,_,A5,A6,A7],I,[A1,A2,A3,I,A5,A6,A7]).

% Modifica el campo Losses de Player.
% Dom: Player x int
% Rec: Player
player_losses_set([A1,A2,A3,A4,_,A6,A7],I,[A1,A2,A3,A4,I,A6,A7]).

% Modifica el campo Draws de Player.
% Dom: Player x int
% Rec: Player
player_draws_set([A1,A2,A3,A4,A5,_,A7],I,[A1,A2,A3,A4,A5,I,A7]).

% Modifica el campo RemainingPieces de Player.
% Dom: Player x int
% Rec: Player
player_rem_set([A1,A2,A3,A4,A5,A6,_],I,[A1,A2,A3,A4,A5,A6,I]).

/* Funciones */
% Verifica si el jugador no tiene piezas restantes.
% Dom: Player
% Rec: void
player_no_pieces(P):-
	player_rem(P,Rem),
	Rem = 0.

% Actualiza las estadísticas del jugador, si ha perdido, ganado o empatado.
% Dom: Player x caso (int)
% Rec: Player
% Nota: Caso 0, el jugador perdió.
/*0 = Loss, 1 = Win, 2 = Draw*/
player_update_stats(P,0,NewP):-
	player_losses(P,L),
	L2 is L+1,
	player_losses_set(P,L2,NewP).
	
% Nota: Caso 1, el jugador ganó.
player_update_stats(P,1,NewP):-
	player_wins(P,L),
	L2 is L+1,
	player_wins_set(P,L2,NewP).

% Nota: Caso 2, el jugador empató.
player_update_stats(P,2,NewP):-
	player_draws(P,L),
	L2 is L+1,
	player_draws_set(P,L2,NewP).

% Añade (Add) piezas al jugador. Como es una suma, también sirve para
% quitar piezas, dado un número negativo en Add.
% Dom: Player x int
% Rec: Player
player_update_pieces(P,Add,NewP):-
	player_rem(P,Pz),
	Pz2 is Pz+Add,
	player_rem_set(P,Pz2,NewP).
