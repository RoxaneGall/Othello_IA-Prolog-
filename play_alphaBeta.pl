evaluateAndChoose(Heur,Player,[(Line,Column)|Moves],D,CurrentGrid,Token,Alpha,Beta,CurrentBestMove,BestMove) :-
    doMove(CurrentGrid,Line,Column,Token,NewGrid),
    alphaBeta(Heur,Player,D,NewGrid,Token,Alpha,Beta,(_,_),V),
    Value is -V,
    cuttOff(Heur,Player,(Line,Column),Value,D,Alpha,Beta,Moves,CurrentGrid,Token,CurrentBestMove,BestMove).

evaluateAndChoose(_,_,[],_,CurrentGrid,Token,Alpha,_,Move,(Move,Alpha)) :- 
    canMove(CurrentGrid,Token).

evaluateAndChoose(_,Player,[],D,CurrentGrid,Token,Alpha,Beta,_,((_,_),Value)) :- 
    endGame(CurrentGrid), 
    alphaBeta(endGame,Player,D,CurrentGrid,Token,Alpha,Beta,(_,_),Value).

evaluateAndChoose(Heur,Player,[],D,CurrentGrid,Token,Alpha,Beta,_,(Move,Value)) :- 
    alphaBeta(Heur,Player,D,CurrentGrid,Token,Alpha,Beta,Move,Value).

alphaBeta(Heur,Player,0,Grid,_,_,_,_,Value) :- 
    heuristic(Heur,Grid,Player,Value).

alphaBeta(Heur,Player,D,Grid,Token,Alpha,Beta,Move,Value):- 
    D>0,
    NextD is D-1,
    NextAlpha is -Beta,
    NextBeta is -Alpha,
    next(Token,NextToken),
    allPossibleMoves(NextToken,Grid,AllMoves),
    evaluateAndChoose(Heur,Player,AllMoves,NextD,Grid,NextToken,NextAlpha,NextBeta,((_,_),-10000),(Move,Value)).

cuttOff(_,_,Move,Value,_,_,Beta,_,_,_,_,(Move,Value)) :- 
    Value>=Beta.

cuttOff(Heur,Player,Move,Value,D,Alpha,Beta,Moves,Grid,Token,_,BestMove) :- 
    Alpha<Value,
    Value<Beta,
    evaluateAndChoose(Heur,Player,Moves,D,Grid,Token,Value,Beta,Move,BestMove).

cuttOff(Heur,Player,_,Value,D,Alpha,Beta,Moves,Grid,Token,CurrentBestMove,BestMove) :-
    Value=<Alpha,
    evaluateAndChoose(Heur,Player,Moves,D,Grid,Token,Alpha,Beta,CurrentBestMove,BestMove).