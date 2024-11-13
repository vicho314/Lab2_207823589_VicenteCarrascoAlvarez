use_module(library(apply)).
cons(A,B,A|B).
car(A|_,A).
cdr(_|B,B).

size_to_size(L2,Y1,Y,Len):-
	Y1 < Y,
	nth0(Y1,L2,A),
	length(A,Len),
	B is Y1+1,
	size_to_size(L2,B,Y,Len).

size_to_size(_,Y,Y,_):-
	!.

term_to_term(Lcols,Y1,X1,L2):-
	nth0(X1,Lcols,C1),
	nth0(Y1,C1,V),
	nth0(Y1,L2,C2),
	nth0(X1,C2,V).

terms_wrap(Lcols,X1,X,Y1,Y,L2):-
	term_to_term(Lcols,Y1,X1,L2),
	X2 is X1+1,
	terms_wrap(Lcols,X2,X,Y1,Y,L2).

terms_wrap(Lcols,X,X,Y1,Y,L2):-
	Y2 is Y1+1,
	terms_wrap(Lcols,0,X,Y2,Y,L2).



terms_wrap(_,_,_,Y,Y,_):-
	!.
	
transpose(Lcols, L2):-
	nth0(0,Lcols,A),
	length(Lcols,X),
	length(A,Y),
	length(L2,Y),
	size_to_size(L2,0,Y,X),
	terms_wrap(Lcols,0,X,0,Y,L2).

use_module(library(apply)).
use_module(library(lists)).

in_bounds(X,Y):-
	X >= 0,
	X < 7,
	Y >= 0,
	Y < 6.

write_list_aux(L,_,_,L2,I):-
	length(L,I),
	length(L2,I),
	!.

write_list_aux(L,N,V,L2,N):-
	nth0(N,L2,V),
	N2 is N+1,
	write_list_aux(L,N,V,L2,N2).

write_list_aux(L,N,V,L2,I):-
	nth0(I,L2,V0),
	nth0(I,L,V0),
	I2 is I+1,
	write_list_aux(L,N,V,L2,I2).

write_list(L,N,V,L2):-
	write_list_aux(L,N,V,L2,0).

board_getxy(A,X,Y,V0):-
	nth0(X,A,L),
	nth0(Y,L,V0).

diag_ascen_get(A,X,Y,C,B):-
	in_bounds(X,Y),
	board_getxy(A,X,Y,V0),
	nth0(C,B,V0),
	K is C+1,
	X2 is X+1,
	Y2 is Y+1,
	diag_ascen_get(A,X2,Y2,K,B).

