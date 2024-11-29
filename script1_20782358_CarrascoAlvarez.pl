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
main(P1,P2,P3,Pz1,Pz2,Pz3,EmptyBoard,B1,B2,B3,W1,W2,W3,
W4,W5,W6,W7,W8,W9) :-
% RF2
player(1,"Joestar","red",0,0,0,21,P1),
player(2,"Jotaro","yellow",1,1,1,20,P2),
player(3,"Savannha","green",1,3,4,1,P3),
% RF3
piece("red",Pz1),
piece("yellow",Pz2),
piece("prussian-blue",Pz3),
% RF4
board(EmptyBoard),
% RF5, RF6
can_play(EmptyBoard),
play_piece(EmptyBoard,0,Pz1,B1),
display_board(B1),
play_piece(B1,1,Pz1,B2),
display_board(B2),
play_piece(B2,2,Pz1,B3),
display_board(B3),
can_play(B1),
can_play(B2),
can_play(B3),
play_piece(B3,4,Pz2,B4),
display_board(B4),
% RF7
check_vertical_win(EmptyBoard,W1),
check_vertical_win(B4,W2),
play_piece(B3,0,Pz1,Ba4),
play_piece(Ba4,0,Pz1,Ba5),
play_piece(Ba5,0,Pz1,Ba6),
check_vertical_win(Ba6,W3),
display_board(Ba6),
% RF8
check_horizontal_win(EmptyBoard,W4),
check_horizontal_win(B4,W5),
play_piece(B4,3,Pz1,B5),
check_horizontal_win(B5,W6),
% RF9
check_diagonal_win(EmptyBoard,W7),
play_piece(B3,1,Pz1,Bb4),
play_piece(Bb4,2,Pz2,Bb5),
play_piece(Bb5,2,Pz1,Bb6),
play_piece(Bb6,3,Pz2,Bb7),
play_piece(Bb7,3,Pz2,Bb8),
play_piece(Bb8,3,Pz2,Bb9),
play_piece(Bb9,3,Pz1,Bb10),
display_board(Bb10),
check_diagonal_win(Bb10,W8),
check_diagonal_win(B5,W9),
% RF10
who_is_winner(Bb10,W8),
who_is_winner(B5,W6),
who_is_winner(EmptyBoard,W1).
