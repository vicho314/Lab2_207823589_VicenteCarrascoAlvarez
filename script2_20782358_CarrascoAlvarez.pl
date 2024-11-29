:- use_module(library(lists)).
:- consult(game_20782358_CarrascoAlvarez).
:- consult(board_20782358_CarrascoAlvarez).
:- consult(player_20782358_CarrascoAlvarez).
:- consult(utils_20782358_CarrascoAlvarez).

/*
* Este código ejecuta hasta 3 veces las funciones
* descritas en los RF, demostrando su validez.
* Para ejecutarlo, llamar a main.
*/
main(G1,G2,G3,H1,H2,H3,EndG5):-
player(1,"Joestar","red",0,0,0,2,P1),
player(2,"Jota","yellow",1,1,1,2,P2),
board(EmptyBoard),
% RF11,RF16
game(P1,P2,EmptyBoard,1,G1),
game(P2,P1,EmptyBoard,2,Ga),
game(P2,P2,EmptyBoard,2,Gb),
game_get_board(G1,B1),
% RF18,RF12,RF15
get_current_player(G1,Cp1),
writeln(Cp1),
player_play(G1,P1,0,G2),
get_current_player(G2,Cp2),
writeln(Cp2),
game_history(G2,H1),
player_play(G2,P2,0,G3),
get_current_player(G3,Cp3),
writeln(Cp3),
game_history(G3,H2),
player_play(G3,P1,1,G4),
game_history(G4,H3),
% RF13
not(is_draw(G2)), /*Si esto es False, el programa falla.*/
not(is_draw(G3)),
not(is_draw(G4)),
% RF14
player_play(G4,P2,1,G5),
update_stats(G5,P1,NewP1),
update_stats(G5,P2,NewP2),
% RF17
end_game(G5,EndG5).
