# Lab2_207823589_VicenteCarrascoAlvarez
Conecta4 en Prolog

## Avance
* [X] Player
* [X] Board
* [X] Game

## Instrucciones de uso
Cargar los scripts individualmente, y llamar a main con
variables en argumentos.

Script base:
```
swipl script_*pl
?- main(P1,P2,RedPiece,YellowPiece,EmptyBoard,G0,G1,
G2,G3,G4,G5,G6,G7,G8,G9,G10,G11,
CurrentBoard,CurrentPlayer,VerticalWinner,
HorizontalWinner,DiagonalWinner,Winner,
EndedGame,History,FinalBoard).
```

* Script1:
```
swipl script1*pl
?- main(P1,P2,P3,Pz1,Pz2,Pz3,EmptyBoard,B1,B2,B3,W1,W2,W3,
W4,W5,W6,W7,W8,W9).
```

* Script2:
```
swipl script2*pl
?- main(G1,G2,G3,H1,H2,H3,EndG5).
```
