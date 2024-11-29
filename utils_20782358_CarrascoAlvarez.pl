/*:- module(utils_20782358_CarrascoAlvarez,[]).*/
:- use_module(library(apply)).
:- use_module(library(lists)).

/* Funciones o TDAs auxiliares */
/*
cons(A,B,A|B).
car(A|_,A).
cdr(_|B,B).
*/

% Verifica recursivamente que las listas de la lista L2 sean 
% todas de largo Len, partiendo desde la lista número Y1 hasta la Y.
% Dom: list x int x int x int
% Rec: void
% Nota: caso general, verificar el largo y seguir con recursión.
size_to_size(L2,Y1,Y,Len):-
	Y1 < Y,
	nth0(Y1,L2,A),
	length(A,Len),
	B is Y1+1,
	size_to_size(L2,B,Y,Len).

% Nota: caso borde, terminar con recursión.
size_to_size(_,Y,Y,_):-
	!.

% Función auxiliar para generar la transpuesta de una matriz.
% Para ello, mapea la posición (X1,Y1) de Lcols a la posición
% (Y1,X1) de L2. No genera toda la matriz transpuesta.
% Dom: list x int x int
% Rec: list
term_to_term(Lcols,Y1,X1,L2):-
	nth0(X1,Lcols,C1),
	nth0(Y1,C1,V),
	nth0(Y1,L2,C2),
	nth0(X1,C2,V).

% Wrapper para usar term_to_term recursivamente, es decir,
% para mapear toda la matriz. Lo hace desde X1 hasta X, y de Y1 hasta Y.
% Dom: list x int x int x int x int
% Rec: list
% Nota: caso general, avanzar en X.
terms_wrap(Lcols,X1,X,Y1,Y,L2):-
	term_to_term(Lcols,Y1,X1,L2),
	X2 is X1+1,
	terms_wrap(Lcols,X2,X,Y1,Y,L2).

% Nota: caso general, avanzar en y.
terms_wrap(Lcols,X,X,Y1,Y,L2):-
	Y2 is Y1+1,
	terms_wrap(Lcols,0,X,Y2,Y,L2).

% Nota: caso borde, terminar en Y.
terms_wrap(_,_,_,Y,Y,_):-
	!.

% Genera la transpuesta de una matriz.
% Dom: list
% Rec: list
transpose(Lcols, L2):-
	nth0(0,Lcols,A),
	length(Lcols,X),
	length(A,Y),
	length(L2,Y),
	size_to_size(L2,0,Y,X),
	terms_wrap(Lcols,0,X,0,Y,L2),
	!.

% Función auxiliar para modificar lista[N] por V.
% El último entero es un contador, y esencialmente esto copia una lista.
% Dom: list x int x atom
% Rec: list x int
% Nota: caso borde, ya se recorrió toda la lista.
write_list_aux(L,_,_,L2,I):-
	length(L,I),
	length(L2,I),
	!.

% Nota: caso borde, se encontró la posición N, reemplazar valor.
write_list_aux(L,N,V,L2,N):-
	nth0(N,L2,V),
	N2 is N+1,
	write_list_aux(L,N,V,L2,N2).

% Nota: caso borde, aún no se encontró la pos. N, seguir recursión.
write_list_aux(L,N,V,L2,I):-
	nth0(I,L2,V0),
	nth0(I,L,V0),
	I2 is I+1,
	write_list_aux(L,N,V,L2,I2).

% Función para modificar lista[N] por V.
% Dom: list x int x atom
% Rec: list
write_list(L,N,V,L2):-
	write_list_aux(L,N,V,L2,0).

/*TDA Stack*/
% Constructor TDA stack.
% Dom: void
% Rec: stack (list)
stack([]).

% Apila un valor en la pila/stack.
% Dom: stack x atom
% Rec: stack
stack_push(St1,V,St2):-
	append([V],St1,St2).


% Retorna el valor en el tope de la pila/stack.
% Dom: stack
% Rec: atom
stack_top(St1,V):-
	nth0(0,St1,V).


% Desapila el valor en el tope de la pila/stack.
% Dom: stack
% Rec: stack
stack_pop(St1,St2):-
	stack_top(St1,V),
	append([V],St2,St1). /*Sipo*/
