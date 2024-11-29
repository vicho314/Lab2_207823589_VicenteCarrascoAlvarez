:- use_module(library(lists)).
:- consult(game_20782358_CarrascoAlvarez).
:- consult(board_20782358_CarrascoAlvarez).
:- consult(player_20782358_CarrascoAlvarez).
:- consult(utils_20782358_CarrascoAlvarez).

main(P1,P2,P3) :-
% RF2
player(1,"Joestar","red",0,0,0,21,P1),
player(2,"Jotaro","yellow",1,1,1,20,P2),
player(3,"Savanha","green",1,3,4,1,P3).
