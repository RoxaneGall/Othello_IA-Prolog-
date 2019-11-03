%Grille initiale
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


%Affichage (grille et ligne)
displayGrid(Grid,Token) :-
    length(Grid,Nblines),
    nl, write("  AU TOUR DES "), write(Token), nl, nl,
    forall(between(1, Nblines, Line), (nth1(Line,Grid,CharList), displayRow(CharList), nl)),
    nl.

displayRow(CharList) :-
    length(CharList,Nbcol),
    write("  "),
    forall(between(1, Nbcol, Col),(nth1(Col,CharList,Char), write(Char), write(" "))).


%Edition (grille et ligne)
editGrid(NewChar,Lin,Col,Grid,NewGrid) :- editGrid(NewChar,0,Lin,Col,Grid,NewGrid).
editGrid(NewChar,CurrentLin,Lin,Col,[Head|Tail],[Head|Grid_out]) :- 
    CurrentLin\==Lin, 
    incr(CurrentLin,NextLin), 
    editGrid(NewChar,NextLin,Lin,Col,Tail,Grid_out).
editGrid(NewChar,CurrentLin,CurrentLin,Col,[CharList|Tail],[NewCharList|Grid_out]) :- 
    incr(CurrentLin,NextLin), 
    editRow(NewChar,Col,CharList,NewCharList),
    editGrid(NewChar,NextLin,CurrentLin,Col,Tail,Grid_out).
editGrid(_,_,_,_,[],[]).

editRow(NewChar,Col,CharList,NewCharList) :- editRow(NewChar,0,Col,CharList,NewCharList).
editRow(NewChar,CurrentCol,Col,[Head|Tail],[Head|CharList_out]) :- 
    CurrentCol\==Col,
    incr(CurrentCol,NextCol), 
    editRow(NewChar,NextCol,Col,Tail,CharList_out).
editRow(NewChar,CurrentCol,CurrentCol,[_|Tail],[NewChar|CharList_out]) :- 
    incr(CurrentCol,NextCol), 
    editRow(NewChar,NextCol,CurrentCol,Tail,CharList_out).
editRow(_,_,_,[],[]).


%isValidMove/4:
% verifie que la place choisie est libre (isEmpty/3),
% verifie que des jetons adverses sont manges(canFlipOpponentTokens/6).
isValidMove(Grid,Line,Column,Player) :-
    isEmpty(Grid,Line,Column),
    direction(Dir),
    canFlipOpponentTokens(0,Grid,Line,Column,Player,Dir).

isEmpty(Grid,Line,Column) :- element(Grid,Line,Column,"-").

canFlipOpponentTokens(NbTokenMoved,Grid,Lin,Col,Player,Direction) :-
    direction(Direction, Lin, Col, NextLin, NextCol),
    element(Grid,NextLin,NextCol,Token),
    canFlip(Player,Token),
    incr(NbTokenMoved,NewNbTokenMoved),
    canFlipOpponentTokens(NewNbTokenMoved,Grid,NextLin,NextCol,Player,Direction).

canFlipOpponentTokens(NbTokenMoved,Grid,Lin,Col,Player,Direction) :-
    direction(Direction, Lin, Col, NextLin, NextCol),
    element(Grid,NextLin,NextCol,Token),
    equal(Player,Token),
    NbTokenMoved\==0.


%Modification de la grille
doMove(Grid,Line,Column,Player,FinalGrid) :-
    editGrid(Player,Line,Column,Grid,NewGrid),
    tryMove(NewGrid,Line,Column,NewGrid1,bas),
    tryMove(NewGrid1,Line,Column,NewGrid2,basDroite),
    tryMove(NewGrid2,Line,Column,NewGrid3,droite),
    tryMove(NewGrid3,Line,Column,NewGrid4,hautDroite),
    tryMove(NewGrid4,Line,Column,NewGrid5,haut),
    tryMove(NewGrid5,Line,Column,NewGrid6,hautGauche),
    tryMove(NewGrid6,Line,Column,NewGrid7,gauche),
    tryMove(NewGrid7,Line,Column,FinalGrid,basGauche).


tryMove(Grid,Lin,Col,FinalGrid,Direction) :- move(Grid,Lin,Col,FinalGrid,Direction).
tryMove(Grid,_,_,Grid,_).


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


%Fin de partie
getPlayerNature(x,x, Winner, _, Winner).
getPlayerNature(o,x, _, Winner, Winner).
getPlayerNature(o,o, Winner, _, Winner).
getPlayerNature(x,o, _, Winner, Winner).

announceWinner(Grid, CurrentToken, CurrentPlayerNature, NextPlayerNature) :-
    countTokens(Grid, x, 0, Nx),
    countTokens(Grid, o, 0, No),
    winner(Nx,No,Winner),
    getPlayerNature(Winner, CurrentToken, CurrentPlayerNature, NextPlayerNature, WinnerNature),
    write("       x: "), write(Nx), nl,
    write("       o: "), write(No), nl,
    write("       WINNER IS : "), write(WinnerNature), write(" ("), write(Winner), write(")."),nl,nl.

announceWinner(_, _, _, _) :-
    write("THERE IS NO WINNER").

countTokens([Head|Tail], Token, N, FinalN) :-
    countTokensInRow(Head, Token, N, NewN),
    countTokens(Tail, Token, NewN, FinalN).

countTokens([],_,N,N).

countTokensInRow([Head|Tail], Token, N, FinalN) :-
    equal(Head,Token),
    incr(N,NewN),
    countTokensInRow(Tail,Token,NewN,FinalN).

countTokensInRow([_|Tail], Token, N, FinalN) :- countTokensInRow(Tail,Token,N,FinalN).
countTokensInRow([],_,N,N).


%Regles
canFlip(x,o).
canFlip(o,x).

winner(Nx,No,x) :- Nx > No.
winner(Nx,No,o) :- Nx < No.


%Outils
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
direction(hautDroite,Lin,Col,NextLin,NextCol) :- incr(Col,NextCol), decr(Lin,NextLin).
direction(haut,Lin,Col,NextLin,Col) :- decr(Lin,NextLin).
direction(hautGauche,Lin,Col,NextLin,NextCol) :- decr(Lin,NextLin), decr(Col,NextCol).
direction(gauche,Lin,Col,Lin,NextCol) :- decr(Col,NextCol).
direction(basGauche,Lin,Col,NextLin,NextCol) :- incr(Lin,NextLin), decr(Col,NextCol).

element(Grid,Line,Col,Element) :- nth0(Line,Grid,CharList), nth0(Col,CharList,Element).

equal(Token,Token).

incr(X, X1) :- X1 is X+1.
decr(X, X1) :- X1 is X-1.
