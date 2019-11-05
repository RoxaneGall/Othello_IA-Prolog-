
minmax(Token,Grid,Line,Column) :- 
    all_possible_moves(Token, Grid, AllMoves),
    minmax(max,h1,Token,2,Grid,AllMoves,-inf,_,_,Line,Column,_).


%cas d'une grille en fin de jeu (pas de move possible d'ou [])
minmax(_,Heur,Token,_,CurrentGrid,[],_,Line,Column,Line,Column,FinalEval) :-
    endGame(CurrentGrid),
    heuristic(Heur,CurrentGrid,Token,FinalEval).

%Plus de move possible ou fin du jeu
minmax(_,_,_,_,_,[],FinalEval,FinalLine,FinalColumn,FinalLine,FinalColumn,FinalEval).

minmax(Comparator,Heur,Token,0,CurrentGrid,[[Line,Column]|RemainingMoves],CurrentEval,CurrentLine,CurrentColumn,FinalLine,FinalColumn,FinalEval) :- 
    doMove(CurrentGrid,Line,Column,Token,NewGrid),
    heuristic(Heur,NewGrid,Token,Eval),
    compare(Comparator,Eval,CurrentEval,NewEval,Line,Column,CurrentLine,CurrentColumn,NewLine,NewColumn),
    minmax(Comparator,Heur,Token,0,CurrentGrid,RemainingMoves,NewEval,NewLine,NewColumn,FinalLine,FinalColumn,FinalEval).

minmax(Comparator,Heur,Token,CurrentDepth,CurrentGrid,[[Line,Column]|RemainingMoves],CurrentEval,CurrentLine,CurrentColumn,FinalLine,FinalColumn,FinalEval) :- 
    doMove(CurrentGrid,Line,Column,Token,NewGrid),
    next(Comparator,NextComparator,NextInitEval),
    next(Token,NextToken),
    decr(CurrentDepth,NextDepth),
    all_possible_moves(NextToken, NewGrid, NextDepthAllMoves),
    minmax(NextComparator,Heur,NextToken,NextDepth,NewGrid,NextDepthAllMoves,NextInitEval,Line,Column,_,_,Eval),
    compare(Comparator,Eval,CurrentEval,NewEval,Line,Column,CurrentLine,CurrentColumn,NewLine,NewColumn),
    minmax(Comparator,Heur,Token,CurrentDepth,CurrentGrid,RemainingMoves,NewEval,NewLine,NewColumn,FinalLine,FinalColumn,FinalEval).

minmax(Comparator,Heur,Token,D,)



compare(min,NewEval,CurrentEval,NewEval,L,C,_,_,L,C) :- NewEval < CurrentEval.
compare(min,Eval,NewEval,NewEval,_,_,L,C,L,C).

compare(max,NewEval,CurrentEval,NewEval,L,C,_,_,L,C) :- NewEval > CurrentEval.
compare(max,Eval,NewEval,NewEval,_,_,L,C,L,C).

next(min,max,-inf).
next(max,min,inf).
next(x,o).
next(o,x).

% Générer arbre avec toutes les coordonn�es des coups valides
all_possible_moves(Token, Grid, AllMoves) :-
   findall([Line, Column],
   isValidMove(Grid,Line,Column,Token),
   AllMoves).
all_possible_moves(_, _, []).

%to improve performance we cache the results and try to retrieve it

heuristic(Heur,Grid,Token,Eval) :-
    variant_hash([Heur,Grid,Token],Key),
    get(Key, Eval).

heuristic(Heur,Grid,Token,Eval) :-
    next(Token,Opponent),
    variant_hash([Heur,Grid,Opponent],Key),
    get(Key, OpponentEval),
    Eval is OpponentEval * -1.

heuristic(h1,Grid,Token,Eval) :-
    countTokens(Grid, Token, 0, NbTokensCurrentPlayer),
    nextPlayer(Token,Opponent),
    countTokens(Grid, Opponent, 0, NbTokensOpponent),
    Eval is NbTokensCurrentPlayer-NbTokensOpponent,
    variant_hash([h1,Grid,Token],Key),
    set(Key, Eval).