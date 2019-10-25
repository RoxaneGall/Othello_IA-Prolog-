initialGrid([
[" ", "A", "B", "C", "D", "E", "F", "G", "H"],
["1", "-", "-", "-", "-", "-", "-", "-", "-"],
["2", "-", "-", "-", "-", "-", "-", "-", "-"],
["3", "-", "-", "-", "-", "-", "-", "-", "-"],
["4", "-", "-", "-",  o,  x,   "-", "-", "-"],
["5", "-", "-", "-",  x,  o,   "-", "-", "-"],
["6", "-", "-", "-", "-", "-", "-", "-", "-"],
["7", "-", "-", "-", "-", "-", "-", "-", "-"],
["8", "-", "-", "-", "-", "-", "-", "-", "-"]
]).

displayGrid(Grid,Player) :-
    length(Grid,Nblines),
    nl, write("  AU TOUR DES "), write(Player), nl, nl,
    forall(between(1, Nblines, Line), (nth1(Line,Grid,CharList), displayRow(CharList), nl)),
    nl.


displayRow(CharList) :- 
    length(CharList,Nbcol),
    write("  "),
    forall(between(1, Nbcol, Col),(nth1(Col,CharList,Char), write(Char), write(" "))). 


doMove(Grid,Line,Column,Player,NewGrid) :-
    fail.


moveRight(Grid,Line,Col,NewGrid) :- 
    incr(Col,Col1),
    element(Grid,Line,Col,Token1),
    element(Grid,Line,Col1,Token2),
    canFlip(Token1,Token2),
    moveRight(Grid,Line,Col1,NewGrid).

moveRight(Grid,Line,Col,NewGrid) :- 
    incr(Col,Col1),
    element(Grid,Line,Col,Token1),
    element(Grid,Line,Col1,Token2),
    NewGrid=Grid,
    equal(Token1,Token2).

element(Grid,Line,Col,Element) :- nth1(Line,Grid,CharList), nth1(Col,CharList,Element).

equal(Token,Token).
canFlip(x,o).
canFlip(o,x).

incr(X, X1) :-
    X1 is X+1.
