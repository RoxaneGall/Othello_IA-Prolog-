%to improve performance we cache the results and try to retrieve it
isWinner(Nb1,Nb2,inf) :- Nb1 > Nb2.
isWinner(_,_,-inf).

heuristic(_,Grid,Token,Eval) :-
    endGame(Grid),
    next(Token,Opponent),
    countTokens(Grid, Token, 0, Nb1),
    countTokens(Grid, Opponent, 0, Nb2),
    isWinner(Nb1,Nb2,Eval).

heuristic(countTokens,Grid,Token,Eval) :-
    countTokens(Grid, Token, 0, NbTokensCurrentPlayer),
    nextPlayer(Token,Opponent),
    countTokens(Grid, Opponent, 0, NbTokensOpponent),
    Eval is NbTokensCurrentPlayer-NbTokensOpponent.

heuristic(countMoves,Grid,Token,Eval) :-
    all_possible_moves(Token, Grid, AllMovesMax), length(AllMovesMax, Nb_MaxMoves),
    nextPlayer(Token,Opponent),
    all_possible_moves(Opponent, Grid, AllMovesMin), length(AllMovesMin, Nb_MinMoves),
    Eval is Nb_MaxMoves - Nb_MinMoves.