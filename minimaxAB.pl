% Générer arbre avec toutes les coordonnées des coups valides
allPossibleMoves(Player, Grid, AllMoves) :-
   %write("Tous les coups possibles pour "), write(Player),
   findall([Line, Column],
   isValidMove(Grid,Line,Column,Player),AllMoves).
   %write(" sont "), write(AllMoves), nl.


evaluateAndChoose([[Line,Column]|Moves],Grid,Player,Player2,D,Alpha,Beta,Move1,BestMove):-
   doMove(Grid,Line,Column,Player,NewGrid),
   alphaBeta(NewGrid,Player,Player2,D,Alpha,Beta,Move1,Value),
   Value1 is -Value,
   cutoff([Line,Column],Value1,Grid,Player,Player2,D,Alpha,Beta,Moves,Move1,BestMove).

evaluateAndChoose([],Grid,Player,Player2,D,Alpha,Beta,BestMove).


alphaBeta(Grid,Player,Player2,0,Alpha,Beta,Move,Value):-
   value(Grid,Value).

alphaBeta(Grid,Player,Player2,D,Alpha,Beta,Move,Value):-
   allPossibleMoves(Player,Grid,AllMoves),
   Alpha1 is -Beta,
   Beta1 is -Alpha,
   D1 is D-1,
   evaluateAndChoose(AllMoves,Grid,Player,Player2,D1,Alpha1,Beta1,nil,(Move,Value)).


cutoff(Move,Value,Grid,Player,Player2,D,Alpha,Beta,Moves,Move1,BestMove):-
   Value >= Beta.

cutoff(Move,Value,Grid,Player,Player2,D,Alpha,Beta,Moves,Move1,BestMove):-
   Alpha < Value, Value < Beta,
   evaluateAndChoose(Moves,Grid,Player,Player2,D,Value,Beta,Move1,BestMove).

cutoff(Move,Value,Grid,Player,Player2,D,Alpha,Beta,Moves,Move1,BestMove):-
   Value =< Beta,
   evaluateAndChoose(Moves,Grid,Player,Player2,D,Alpha,Beta,Move1,BestMove).
