evaluateAndChoose(Heur,Player,[(Line,Column)|Moves],D,CurrentGrid,Token,MinMax,Alpha,Beta,CurrentBestMove,BestMove) :-
    doMove(CurrentGrid,Line,Column,Token,NewGrid),
    alphaBeta(Heur,Player,D,NewGrid,Token,MinMax,Alpha,Beta,(_,_),Value),
    cuttOff(Heur,Player,(Line,Column),Value,D,Alpha,Beta,Moves,CurrentGrid,Token,MinMax,CurrentBestMove,BestMove)
    %,write(" D= "),write(D),write(" currentBestMove: "),write(CurrentBestMove),write(" newMove: "),write(((Line,Column),Value)),write(" bestMove: "),write(BestMove),nl
    .

evaluateAndChoose(_,_,[],_,CurrentGrid,Token,_,_,_,Move,Move) :- 
    canMove(CurrentGrid,Token).

evaluateAndChoose(_,Player,[],D,CurrentGrid,Token,MinMax,Alpha,Beta,_,((_,_),Value)) :- 
    endGame(CurrentGrid), 
    alphaBeta(endGame,Player,D,CurrentGrid,Token,MinMax,Alpha,Beta,(_,_),Value).

evaluateAndChoose(Heur,Player,[],D,CurrentGrid,Token,MinMax,Alpha,Beta,_,(Move,Value)) :- 
    alphaBeta(Heur,Player,D,CurrentGrid,Token,MinMax,Alpha,Beta,Move,Value).

alphaBeta(Heur,Player,0,Grid,_,MinMax,_,_,_,Value) :- 
    heuristic(Heur,Grid,Player,V),
    Value is MinMax*V.

alphaBeta(Heur,Player,D,Grid,Token,MinMax,Alpha,Beta,Move,Value):- 
    D>0,
    NextD is D-1,
    MaxMin = -MinMax,
    NextAlpha is -Beta,
    NextBeta is -Alpha,
    next(Token,NextToken),
    allPossibleMoves(NextToken,Grid,AllMoves),
    evaluateAndChoose(Heur,Player,AllMoves,NextD,Grid,NextToken,MaxMin,NextAlpha,NextBeta,((_,_),-10000),(Move,V)),
    Value is -V.

cuttOff(_,_,Move,Value,_,_,Beta,_,_,_,_,_,(Move,Value)) :-
    Value>=Beta.

cuttOff(Heur,Player,Move,Value,D,Alpha,Beta,Moves,Grid,Token,MinMax,_,BestMove) :- 
    Alpha<Value,
    Value<Beta,
    evaluateAndChoose(Heur,Player,Moves,D,Grid,Token,MinMax,Value,Beta,(Move,Value),BestMove).

cuttOff(Heur,Player,_,Value,D,Alpha,Beta,Moves,Grid,Token,MinMax,CurrentBestMove,BestMove) :-
    Value=<Alpha,
    evaluateAndChoose(Heur,Player,Moves,D,Grid,Token,MinMax,Alpha,Beta,CurrentBestMove,BestMove).