%Jouer en utilisant minMax:
minmax(Heur,Player,D,Grid,Token,Move):- 
    D>0,
    allPossibleMoves(Token,Grid,AllMoves),
    NextD is D-1,
    choose(Heur,Player,AllMoves,NextD,Grid,Token,1,((_,_),-10000),(Move,_)).

%Effectuer un mouvement et le comparer au meilleur et l'utiliser pour la suite si encore meilleur
choose(Heur,Player,[(Line,Column)|Moves],D,CurrentGrid,Token,MaxMin,CurrentBestMove,BestMove) :-
    doMove(CurrentGrid,Line,Column,Token,NewGrid),
    minmax(Heur,Player,D,NewGrid,Token,MaxMin,(_,_),Value),
    update((Line,Column),Value,CurrentBestMove,NewBestMove),
    choose(Heur,Player,Moves,D,CurrentGrid,Token,MaxMin,NewBestMove,BestMove).

%Si tout les mouvements possibles ont ete essayes.
choose(_,_,[],_,CurrentGrid,Token,_,BestMove,BestMove) :- 
    canMove(CurrentGrid,Token). %Pour s'assurer qu'il y avait des mouvements possibles

%Si il n'y avait pas de mouvement possible car c'etait la fin du jeu.
choose(_,Player,[],_,CurrentGrid,Token,MaxMin,_,((_,_),Value)) :- 
    endGame(CurrentGrid), 
    minmax(endGame,Player,0,CurrentGrid,Token,MaxMin,(_,_),Value).

%Si il n'y avait pas de mouvement possible var le joueur devait passer son tour.
choose(Heur,Player,[],D,CurrentGrid,Token,MaxMin,_,(Move,Value)) :- 
    minmax(Heur,Player,D,CurrentGrid,Token,MaxMin,Move,Value).

%Evaluation de l'heuristique pour depth=0.
minmax(Heur,Player,0,Grid,_,MaxMin,(_,_),Value) :- 
    heuristic(Heur,Grid,Player,V),
    Value is V*MaxMin.

%Evaluation de tout les mouvements possibles.
minmax(Heur,Player,D,Grid,Token,MaxMin,Move,Value) :- 
    D>0,
    NextD is D-1,
    MinMax is -MaxMin,
    next(Token,NextToken),
    allPossibleMoves(NextToken,Grid,AllMoves),
    choose(Heur,Player,AllMoves,NextD,Grid,NextToken,MinMax,((_,_),-10000),(Move,V)),
    Value is -V.

%Predicat pour selectionner le meilleur mouvement 
update((Line,Column),Value,((_,_),CurrentValue),((Line,Column),Value)) :- Value > CurrentValue.
update((_,_),_,((Line,Column),Value),((Line,Column),Value)).

%Util stuff
next(min,max,-inf).
next(max,min,inf).
next(x,o).
next(o,x).

% Générer arbre avec toutes les coordonn�es des coups valides
allPossibleMoves(Token, Grid, AllMoves) :-
   findall((Line, Column),
   isValidMove(Grid,Line,Column,Token),
   AllMoves).
allPossibleMoves(_, _, []).
