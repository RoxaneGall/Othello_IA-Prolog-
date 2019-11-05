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