%to improve performance we cache the results and try to retrieve it

heuristic(Heur,Grid,Token,Eval) :-
    variant_hash([Heur,Grid,Token],Key),
    get(Key, Eval).

heuristic(Heur,Grid,Token,Eval) :-
    next(Token,Opponent),
    variant_hash([Heur,Grid,Opponent],Key),
    get(Key, OpponentEval),
    Eval is OpponentEval * -1.

heuristic(countTokens,Grid,Token,Eval) :-
    countTokens(Grid, Token, 0, NbTokensCurrentPlayer),
    nextPlayer(Token,Opponent),
    countTokens(Grid, Opponent, 0, NbTokensOpponent),
    Eval is NbTokensCurrentPlayer-NbTokensOpponent,
    variant_hash([countTokens,Grid,Token],Key),
    set(Key, Eval).

heuristic(countMoves,Grid,Token,Eval) :-
    all_possible_moves(Token, Grid, AllMovesMax), length(AllMovesMax, Nb_MaxMoves),
    nextPlayer(Token,Opponent),
    all_possible_moves(Opponent, Grid, AllMovesMin), length(AllMovesMin, Nb_MinMoves),
    Eval is Nb_MaxMoves - Nb_MinMoves,
    variant_hash([countMoves,Grid,Token],Key),
    set(Key, Eval).