%Jouer en utilisant alphaBeta:
alphaBeta(Heur,Player,D,Grid,Token,Move):- 
    D>0,
    allPossibleMoves(Token,Grid,AllMoves),
    NextD is D-1,
    choose(Heur,Player,AllMoves,NextD,Grid,Token,1,-100000,100000,((_,_),-10000),(Move,_)).

%Effectuer un mouvement et le comparer au meilleur et l'utiliser pour la suite si encore meilleur
choose(Heur,Player,[(Line,Column)|Moves],D,CurrentGrid,Token,MinMax,Alpha,Beta,CurrentBestMove,BestMove) :-
    doMove(CurrentGrid,Line,Column,Token,NewGrid),
    alphaBeta(Heur,Player,D,NewGrid,Token,MinMax,Alpha,Beta,(_,_),Value),
    cuttOff(Heur,Player,(Line,Column),Value,D,Alpha,Beta,Moves,CurrentGrid,Token,MinMax,CurrentBestMove,BestMove).

%Si tout les mouvements possibles ont ete essayes.
choose(_,_,[],_,CurrentGrid,Token,_,_,_,Move,Move) :- 
    canMove(CurrentGrid,Token). %Pour s'assurer qu'il y avait des mouvements possibles

%Si il n'y avait pas de mouvement possible car c'etait la fin du jeu.
choose(_,Player,[],D,CurrentGrid,Token,MinMax,Alpha,Beta,_,((_,_),Value)) :- 
    endGame(CurrentGrid), 
    alphaBeta(endGame,Player,D,CurrentGrid,Token,MinMax,Alpha,Beta,(_,_),Value).

%Si il n'y avait pas de mouvement possible var le joueur devait passer son tour.
choose(Heur,Player,[],D,CurrentGrid,Token,MinMax,Alpha,Beta,_,(Move,Value)) :- 
    alphaBeta(Heur,Player,D,CurrentGrid,Token,MinMax,Alpha,Beta,Move,Value).

%Evaluation de l'heuristique pour depth=0.
alphaBeta(Heur,Player,0,Grid,_,MinMax,_,_,_,Value) :- 
    heuristic(Heur,Grid,Player,V),
    Value is MinMax*V.

%Evaluation de tout les mouvements possibles.
alphaBeta(Heur,Player,D,Grid,Token,MinMax,Alpha,Beta,Move,Value):- 
    D>0,
    NextD is D-1,
    MaxMin = -MinMax,
    NextAlpha is -Beta,
    NextBeta is -Alpha,
    next(Token,NextToken),
    allPossibleMoves(NextToken,Grid,AllMoves),
    choose(Heur,Player,AllMoves,NextD,Grid,NextToken,MaxMin,NextAlpha,NextBeta,((_,_),-10000),(Move,V)),
    Value is -V.

%Predicat pour selectionner le meilleur mouvement et interrompre le parcours des mouvements possibles si necessaire:

cuttOff(_,_,Move,Value,_,_,Beta,_,_,_,_,_,(Move,Value)) :-
    Value>=Beta.

cuttOff(Heur,Player,Move,Value,D,Alpha,Beta,Moves,Grid,Token,MinMax,_,BestMove) :- 
    Alpha<Value,
    Value<Beta,
    choose(Heur,Player,Moves,D,Grid,Token,MinMax,Value,Beta,(Move,Value),BestMove).

cuttOff(Heur,Player,_,Value,D,Alpha,Beta,Moves,Grid,Token,MinMax,CurrentBestMove,BestMove) :-
    Value=<Alpha,
    choose(Heur,Player,Moves,D,Grid,Token,MinMax,Alpha,Beta,CurrentBestMove,BestMove).