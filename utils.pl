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
