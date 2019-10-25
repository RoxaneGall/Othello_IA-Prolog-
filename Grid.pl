initialGrid([
[" ", "A", "B", "C", "D", "E", "F", "G", "H"," "],
["1", "-", "-", "-", "-", "-", "-", "-", "-"," "],
["2", "-", "-", "-", "-", "-", "-", "-", "-"," "],
["3", "-", "-", "-", "-", "-", "-", "-", "-"," "],
["4", "-", "-", "-",  o,  x,   "-", "-", "-"," "],
["5", "-", "-", "-",  x,  o,   "-", "-", "-"," "],
["6", "-", "-", "-", "-", "-", "-", "-", "-"," "],
["7", "-", "-", "-", "-", "-", "-", "-", "-"," "],
["8", "-", "-", "-", "-", "-", "-", "-", "-"," "],
[" ", " ", " ", " ", " ", " ", " ", " ", " "," "]
]).

displayGrid(Grid,Player) :-
    length(Grid,Nblines),
    nl, write("  AU TOUR DES "), canFlip(Player,NextPlayer), write(NextPlayer), nl, nl,
    forall(between(1, Nblines, Line), (nth1(Line,Grid,CharList), displayRow(CharList), nl)),
    nl.

displayRow(CharList) :- 
    length(CharList,Nbcol),
    write("  "),
    forall(between(1, Nbcol, Col),(nth1(Col,CharList,Char), write(Char), write(" "))). 

editRow(NewChar,Col,CharList,NewCharList) :- editRow(NewChar,0,Col,CharList,NewCharList).
editRow(NewChar,CurrentCol,Col,[Head|Tail],[Head|CharList_out]) :- CurrentCol\==Col, incr(CurrentCol,NextCol), editRow(NewChar,NextCol,Col,Tail,CharList_out).
editRow(NewChar,CurrentCol,CurrentCol,[_|Tail],[NewChar|CharList_out]) :- incr(CurrentCol,NextCol), editRow(NewChar,NextCol,CurrentCol,Tail,CharList_out).
editRow(_,_,_,[],[]).

editGrid(NewChar,Lin,Col,Grid,NewGrid) :- editGrid(NewChar,0,Lin,Col,Grid,NewGrid).
editGrid(NewChar,CurrentLin,Lin,Col,[Head|Tail],[Head|Grid_out]) :- CurrentLin\==Lin, incr(CurrentLin,NextLin), editGrid(NewChar,NextLin,Lin,Col,Tail,Grid_out).
editGrid(NewChar,CurrentLin,CurrentLin,Col,[CharList|Tail],[NewCharList|Grid_out]) :- incr(CurrentLin,NextLin), editRow(NewChar,Col,CharList,NewCharList),editGrid(NewChar,NextLin,CurrentLin,Col,Tail,Grid_out).
editGrid(_,_,_,_,[],[]).

isValidMove(Grid,Line,Column,Player) :- 
    isEmpty(Grid,Line,Column),
    direction(Dir1),
    isNextToOpponent(Grid,Line,Column,Player,Dir1),
    direction(Dir2),
    aPlayerTokenIsInDirection(Grid,Line,Column,Player,Dir2).

isEmpty(Grid,Line,Column) :- element(Grid,Line,Column,"-").

isNextToOpponent(Grid,Lin,Col,Player,Direction) :- 
    direction(Direction, Lin, Col, NextLin, NextCol),
    element(Grid,NextLin,NextCol,Neighbor),
    canFlip(Player,Neighbor).

aPlayerTokenIsInDirection(Grid,Lin,Col,Player,Direction) :-
    direction(Direction, Lin, Col, NextLin, NextCol),
    element(Grid,NextLin,NextCol,Token2),
    canFlip(Player,Token2),
    aPlayerTokenIsInDirection(Grid,NextLin,NextCol,Direction).

aPlayerTokenIsInDirection(Grid,Lin,Col,Player,Direction) :- 
    direction(Direction, Lin, Col, NextLin, NextCol),
    element(Grid,NextLin,NextCol,Token2),
    equal(Player,Token2).

doMove(Grid,Line,Column,Player,FinalGrid) :-
    isValidMove(Grid,Line,Column,Player),
    editGrid(Player,Line,Column,Grid,NewGrid),
    move(NewGrid,Line,Column,NewGrid1,bas),
    move(NewGrid1,Line,Column,NewGrid2,basDroite),
    move(NewGrid2,Line,Column,NewGrid3,droite),
    move(NewGrid3,Line,Column,NewGrid4,hautDroite),
    move(NewGrid4,Line,Column,NewGrid5,haut),
    move(NewGrid5,Line,Column,NewGrid6,hautGauche),
    move(NewGrid6,Line,Column,NewGrid7,gauche),
    move(NewGrid7,Line,Column,FinalGrid,basGauche),
    displayGrid(FinalGrid,Player).

direction(bas).
direction(basDroite).
direction(droite).
direction(hautDroite).
direction(haut).
direction(hautGauche).
direction(gauche).
direction(basGauche).

direction(bas,Lin,Col,NextLin,Col) :- incr(Lin,NextLin).
direction(basDroite,Lin,Col,NextLin,NextCol) :- incr(Lin,NextLin), incr(Col,NextCol).
direction(droite,Lin,Col,Lin,NextCol) :- incr(Col,NextCol).
direction(hautDroite,Lin,Col,NextLin,NextCol) :- incr(Lin,NextLin), decr(Col,NextCol).
direction(haut,Lin,Col,NextLin,Col) :- decr(Lin,NextLin).
direction(hautGauche,Lin,Col,NextLin,NextCol) :- decr(Lin,NextLin), decr(Col,NextCol).
direction(gauche,Lin,Col,Lin,NextCol) :- decr(Col,NextCol).
direction(basGauche,Lin,Col,NextLin,NextCol) :- decr(Lin,NextLin), decr(Col,NextCol).

move(Grid,Lin,Col,FinalGrid,Direction) :- 
    direction(Direction, Lin, Col, NextLin, NextCol),
    element(Grid,Lin,Col,Token1),
    element(Grid,NextLin,NextCol,Token2),
    canFlip(Token1,Token2),
    editGrid(Token1,NextLin,NextCol,Grid,NewGrid),
    move(NewGrid,NextLin,NextCol,FinalGrid,Direction).

move(FinalGrid,Lin,Col,FinalGrid,Direction) :- 
    direction(Direction, Lin, Col, NextLin, NextCol),
    element(FinalGrid,Lin,Col,Token1),
    element(FinalGrid,NextLin,NextCol,Token2),
    equal(Token1,Token2).

move(Grid,_,_,Grid,_).

element(Grid,Line,Col,Element) :- nth0(Line,Grid,CharList), nth0(Col,CharList,Element).

equal(Token,Token).
canFlip(x,o).
canFlip(o,x).

incr(X, X1) :- X1 is X+1.
decr(X, X1) :- X1 is X-1.
