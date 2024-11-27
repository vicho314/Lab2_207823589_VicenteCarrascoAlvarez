:- use_module(library(lists)).
:- use_module(game).
:- use_module(board).
:- use_module(player).
:- use_module(utils).
% 1. Crear jugadores (10 fichas cada uno para un juego corto)
player(1, "Juan", "red", 0, 0, 0, 10, P1),
player(2, "Mauricio", "yellow", 0, 0, 0, 10, P2),
% 2. Crear fichas
piece("red", RedPiece),
piece("yellow", YellowPiece),
% 3. Crear tablero inicial vacío
board(EmptyBoard),
% 4. Crear nuevo juego
game(P1, P2, EmptyBoard, 1, G0),
% 5. Realizando movimientos para crear una victoria diagonal
player_play(G0, P1, 0, G1),% Juan juega en columna 0
player_play(G1, P2, 1, G2),% Mauricio juega en columna 1
player_play(G2, P1, 1, G3),% Juan juega en columna 1
15player_play(G3, P2, 2, G4),% Mauricio juega en columna 2
player_play(G4, P1, 2, G5),% Juan juega en columna 2
player_play(G5, P2, 3, G6),% Mauricio juega en columna 3
player_play(G6, P1, 2, G7),% Juan juega en columna 2
player_play(G7, P2, 3, G8),% Mauricio juega en columna 3
player_play(G8, P1, 3, G9),% Juan juega en columna 3
player_play(G9, P2, 0, G10),% Mauricio juega en columna 0
player_play(G10, P1, 3, G11),% Juan juega en columna 3 (victoria diagonal)
% 6. Verificaciones del estado del juego
write('¿Se puede jugar en el tablero vacío? '),
can_play(EmptyBoard), % Si se puede seguir jugando, el programa continuará
nl,
game_get_board(G11, CurrentBoard),
write('¿Se puede jugar después de 11 movimientos? '),
can_play(CurrentBoard),
nl,
write('Jugador actual después de 11 movimientos: '),
get_current_player(G11, CurrentPlayer),
write(CurrentPlayer),
nl,
% 7. Verificaciones de victoria
write('Verificación de victoria vertical: '),
check_vertical_win(CurrentBoard, VerticalWinner),
write(VerticalWinner),
nl,
write('Verificación de victoria horizontal: '),
check_horizontal_win(CurrentBoard, HorizontalWinner),
write(HorizontalWinner),
nl,
write('Verificación de victoria diagonal: '),
check_diagonal_win(CurrentBoard, DiagonalWinner),
write(DiagonalWinner),
nl,
write('Verificación de ganador: '),
who_is_winner(CurrentBoard, Winner),
write(Winner),
nl,
% 8. Verificación de empate
write('¿Es empate? '),
is_draw(G11),
nl,
% 9. Finalizar juego y actualizar estadísticas
end_game(G11, EndedGame),
% 10. Mostrar historial de movimientos
write('Historial de movimientos: '),
game_history(EndedGame, History),
write(History),
nl,
% 11. Mostrar estado final del tablero
write('Estado final del tablero: '),
game_get_board(EndedGame, FinalBoard),
write(FinalBoard).
