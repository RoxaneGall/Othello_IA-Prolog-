
minmax(Token,Grid,Line,Column) :-
    all_possible_moves(Token, Grid, AllMoves),
    minmax(max,countTokens,Token,3,Grid,AllMoves,-inf,_,_,Line,Column,_).

%Plus de move possibles
minmax(_,_,_,_,_,[],FinalEval,FinalLine,FinalColumn,FinalLine,FinalColumn,FinalEval).

%minmax(Comparator,Heur,Token,CurrentDepth,CurrentGrid,[[Line,Column]|RemainingMoves],CurrentEval,CurrentLine,CurrentColumn,FinalLine,FinalColumn,FinalEval) :-
 %   variant_hash([Comparator,Heur,CurrentDepth,CurrentGrid,Token,Line,Column],Key),
  %  get(Key, Eval),
   % compare(Comparator,Eval,CurrentEval,NewEval,Line,Column,CurrentLine,CurrentColumn,NewLine,NewColumn),
    %minmax(Comparator,Heur,Token,CurrentDepth,CurrentGrid,RemainingMoves,NewEval,NewLine,NewColumn,FinalLine,FinalColumn,FinalEval).

%minmax(Comparator,Heur,Token,CurrentDepth,CurrentGrid,[[Line,Column]|RemainingMoves],CurrentEval,CurrentLine,CurrentColumn,FinalLine,FinalColumn,FinalEval) :-
 %   next(Token,NextToken),
  %  variant_hash([Comparator,Heur,CurrentDepth,CurrentGrid,NextToken,Line,Column],Key),
   % get(Key, OpponentEval),
    %Eval is OpponentEval * -1,
    %compare(Comparator,Eval,CurrentEval,NewEval,Line,Column,CurrentLine,CurrentColumn,NewLine,NewColumn),
    %minmax(Comparator,Heur,Token,CurrentDepth,CurrentGrid,RemainingMoves,NewEval,NewLine,NewColumn,FinalLine,FinalColumn,FinalEval).

minmax(Comparator,Heur,Token,0,CurrentGrid,[[Line,Column]|RemainingMoves],CurrentEval,CurrentLine,CurrentColumn,FinalLine,FinalColumn,FinalEval) :-
    doMove(CurrentGrid,Line,Column,Token,NewGrid),
    heuristic(Heur,NewGrid,Token,Eval),
    compare(Comparator,Eval,CurrentEval,NewEval,Line,Column,CurrentLine,CurrentColumn,NewLine,NewColumn),
    minmax(Comparator,Heur,Token,0,CurrentGrid,RemainingMoves,NewEval,NewLine,NewColumn,FinalLine,FinalColumn,FinalEval).

%appelle minmax pour la prochaine branche dans tous les cas
minmax(Comparator,Heur,Token,0,CurrentGrid,RemainingMoves, Eval,Line,Column,FinalLine,FinalColumn,FinalEval) :-
    minmax(Comparator,Heur,Token,0,CurrentGrid,RemainingMoves,Eval,Line,Column,FinalLine,FinalColumn,FinalEval).

minmax(Comparator,Heur,Token,CurrentDepth,CurrentGrid,[[Line,Column]|RemainingMoves],CurrentEval,CurrentLine,CurrentColumn,FinalLine,FinalColumn,FinalEval) :-
    doMove(CurrentGrid,Line,Column,Token,NewGrid),
    next(Comparator,NextComparator,NextInitEval),
    next(Token,NextToken),
    decr(CurrentDepth,NextDepth),
    canMove(NewGrid,NextToken),
    all_possible_moves(NextToken, NewGrid, NextDepthAllMoves),
    minmax(NextComparator,Heur,NextToken,NextDepth,NewGrid,NextDepthAllMoves,NextInitEval,Line,Column,_,_,Eval),
    compare(Comparator,Eval,CurrentEval,NewEval,Line,Column,CurrentLine,CurrentColumn,NewLine,NewColumn),
    %variant_hash([Comparator,Heur,CurrentDepth,CurrentGrid,Token,Line,Column],Key),
    %set(Key, Eval),
    minmax(Comparator,Heur,Token,CurrentDepth,CurrentGrid,RemainingMoves,NewEval,NewLine,NewColumn,FinalLine,FinalColumn,FinalEval).

minmax(Comparator,Heur,Token,CurrentDepth,CurrentGrid,[[Line,Column]|RemainingMoves],CurrentEval,CurrentLine,CurrentColumn,FinalLine,FinalColumn,FinalEval) :- 
    doMove(CurrentGrid,Line,Column,Token,NewGrid),
    endGame(NewGrid),
    heuristic(Heur,CurrentGrid,Token,Eval),
    compare(Comparator,Eval,CurrentEval,NewEval,Line,Column,CurrentLine,CurrentColumn,NewLine,NewColumn),
    %variant_hash([Comparator,Heur,CurrentDepth,CurrentGrid,Token,Line,Column],Key),
    %set(Key, Eval),
    minmax(Comparator,Heur,Token,CurrentDepth,CurrentGrid,RemainingMoves,NewEval,NewLine,NewColumn,FinalLine,FinalColumn,FinalEval).

%cas ou la profondeur suivante est un passage de tour
minmax(Comparator,Heur,Token,CurrentDepth,CurrentGrid,[[Line,Column]|RemainingMoves],CurrentEval,CurrentLine,CurrentColumn,FinalLine,FinalColumn,FinalEval) :- 
    doMove(CurrentGrid,Line,Column,Token,NewGrid),
    canMove(NewGrid,Token),
    all_possible_moves(Token, NewGrid, NextDepthAllMoves),
    NextDepth is CurrentDepth - 2,
    ( NextDepth >= 0 ->
    next(_,Comparator,InitEval),
    minmax(Comparator,Heur,Token,NextDepth,NewGrid,NextDepthAllMoves,InitEval,Line,Column,_,_,Eval),
    compare(Comparator,Eval,CurrentEval,NewEval,Line,Column,CurrentLine,CurrentColumn,NewLine,NewColumn); 
    heuristic(Heur,CurrentGrid,Token,Eval),
    compare(Comparator,Eval,CurrentEval,NewEval,Line,Column,CurrentLine,CurrentColumn,NewLine,NewColumn)
    ),
    %variant_hash([Comparator,Heur,CurrentDepth,CurrentGrid,Token,Line,Column],Key),
    %set(Key, Eval),
    minmax(Comparator,Heur,Token,CurrentDepth,CurrentGrid,RemainingMoves,NewEval,NewLine,NewColumn,FinalLine,FinalColumn,FinalEval).


compare(min,NewEval,CurrentEval,NewEval,L,C,_,_,L,C) :- NewEval < CurrentEval.
compare(min,_,NewEval,NewEval,_,_,L,C,L,C).

compare(max,NewEval,CurrentEval,NewEval,L,C,_,_,L,C) :- NewEval > CurrentEval.
compare(max,_,NewEval,NewEval,_,_,L,C,L,C).


%cutoff(_,Value,_,_,_,_,_,Beta,_,_,_):-
%   Value >= Beta.

%cutoff(_,Value,Grid,Player,Player2,D,Alpha,Beta,Moves,Move1,BestMove):-
%   Alpha < Value, Value < Beta,
%   evaluateAndChoose(Moves,Grid,Player,Player2,D,Value,Beta,Move1,BestMove).
%

%cutoff(_,Value,Grid,Player,Player2,D,Alpha,Beta,Moves,Move1,BestMove):-
%   Value =< Beta,
%   evaluateAndChoose(Moves,Grid,Player,Player2,D,Alpha,Beta,Move1,BestMove).
%



%Outils
next(min,NextComparator,NextInitVal,x,NextToken) :-
    NextComparator := max,
    NextInitVal := -inf,
    NextToken := o.

next(Alpha,Beta,Depth,NextAlpha,NextBeta,NextDepth) :-
    NextAlpha is -Beta,
    NextBeta is -Alpha,
    decr(Depth,NextDepth).

next(min,max,-inf).
next(max,min,inf).
next(x,o).
next(o,x).

% Genere arbre avec tous les coups possibles
all_possible_moves(Token, Grid, AllMoves) :-
   findall([Line, Column],
   isValidMove(Grid,Line,Column,Token),
   AllMoves).
all_possible_moves(_, _, []).
