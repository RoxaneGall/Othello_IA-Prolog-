evaluateAndChoose(Heur,Player,[(Line,Column)|Moves],D,CurrentGrid,Token,MaxMin,CurrentBestMove,BestMove) :-
    doMove(CurrentGrid,Line,Column,Token,NewGrid),
    minmax(Heur,Player,D,NewGrid,Token,MaxMin,(_,_),Value),
    update((Line,Column),Value,CurrentBestMove,NewBestMove),
    evaluateAndChoose(Heur,Player,Moves,D,CurrentGrid,Token,MaxMin,NewBestMove,BestMove).

evaluateAndChoose(_,_,[],_,CurrentGrid,Token,_,BestMove,BestMove) :- 
    canMove(CurrentGrid,Token).

evaluateAndChoose(_,Player,[],_,CurrentGrid,Token,MaxMin,_,((_,_),Value)) :- 
    endGame(CurrentGrid), 
    minmax(endGame,Player,0,CurrentGrid,Token,MaxMin,(_,_),Value).

evaluateAndChoose(Heur,Player,[],D,CurrentGrid,Token,MaxMin,_,(Move,Value)) :- 
    minmax(Heur,Player,D,CurrentGrid,Token,MaxMin,Move,Value).

minmax(Heur,Player,0,Grid,_,MaxMin,(_,_),Value) :- 
    heuristic(Heur,Grid,Player,V),
    Value is V*MaxMin.

minmax(Heur,Player,D,Grid,Token,MaxMin,Move,Value) :- 
    D>0,
    NextD is D-1,
    MinMax is -MaxMin,
    next(Token,NextToken),
    allPossibleMoves(NextToken,Grid,AllMoves),
    evaluateAndChoose(Heur,Player,AllMoves,NextD,Grid,NextToken,MinMax,((_,_),-10000),(Move,V)),
    Value is -V.

update((Line,Column),Value,((_,_),CurrentValue),((Line,Column),Value)) :- Value > CurrentValue.
update((_,_),_,((Line,Column),Value),((Line,Column),Value)).

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
