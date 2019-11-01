%ia_minimax4(Grid, Player, Player2, Line, Column) :-
%	Depth \= 0,
%	\endGame(grid).

% IA MINI MAX

% Grid est la grille évaluée
% Depth est la profondeur càd le nb de tours
% futurs pour lesquels on va évaluer tous les coups possibles afin
% d'optimiser ce que l'IA doit jouer Player est le joueur correspondant
% à l'IA
% eval représente ici le nombre de pions de différence entre le joueur
% IA et le joueur adverse (par exemple si l'IA a 15 pions et
% l'adversaire 11 : eval = 4 ; si l'IA a 2 pions et l'adversaire 10 :
% eval = -8).

% EvalMax est initialisée à -61
max(Grid, Depth, Player, GridResult,EvalMax) :-
    %write(" tryMax "), nl,
    %NextGrid correspond à l'enfant du noeud IA qui a l'heuristique maximale
    tryMax(Grid, Depth, Player,GridResult,EvalMax), !.

% maxHeuristic fait que GridResult est toujours la grille max
maxHeuristic(GridResult,EvalMax,GridResult,Player).
maxHeuristic(GridResult,EvalMax,Grid,Player) :-
    evaluateH1Max(Grid,Player,Eval),
    getMax(GridResult,EvalMax,Grid,Eval,Player),!.

getMax(GridResult,EvalMax,Grid,Eval,Player) :-
    Eval =< EvalMax.
    % write("La grille évaluée a une eval="),write(Eval), write(" inférieur à l'eval max")
getMax(GridResult,EvalMax,Grid,Eval,Player) :-
    Eval>EvalMax,
    % write("L'eval est supérieur à l'evalMax. "),
    maxHeuristic(Grid,Eval,Grid,Player). % on remplace GridResult par Grid et EvalMax par Eval
    %write("La grille max est celle d'eval="), write(Eval), nl

mini(Grid, Depth, Player, GridResult,EvalMin) :-
    %write(" tryMini "), nl,
    %NextPossibleGrids correspond aux enfant du noeud Other, on ajoutera au fur et à mesure les grilles enfants avec leur eval d'heuristique
    tryMini(Grid, Depth, Player, GridResult, EvalMin), !.


% GridMax est la 1ere grille dont l'eval est maximale
miniHeuristic(GridResult,EvalMin,GridResult,Player).
miniHeuristic(GridResult,EvalMin,Grid,Player) :-
    evaluateH1Min(Grid,Player,Eval),
    getMin(GridResult,EvalMin,Grid,Eval).

getMin(GridResult,EvalMin,Grid,Eval) :-
    Eval >= EvalMin.
    %write("La grille évaluée a une eval supérieur à l'eval min").
getMin(GridResult,EvalMin,Grid,Eval) :-
    Eval<EvalMin,
    %write("L'eval est inférieure à l'evalMin. "),
    miniHeuristic(Grid,Eval,Grid,Player). % on remplace GridResult par Grid et EvalMin par Eval

% si le jeu est fini
% on dit que la profondeur est de 0
tryMax(Grid, Depth, Player, GridResult, EvalMax) :-
   endGame(Grid),
   Depth=0,
   tryMax(Grid, Depth, Player, GridResult,EvalMax).
% si la profondeur est de 0
% on évalue l'état de la grille en paramètre : Eval correspond à
% l'heuristique
tryMax(Grid, Depth, Player,GridResult,EvalMax) :-
    depthReached(Depth),
    %write("Depth ia ="), write(Depth), nl,
    maxHeuristic(GridResult,EvalMax,Grid,Player).
% sinon on exécute l'algo
% cas où on évalue pour l'ia (maximizing)
tryMax(Grid, Depth, Player,GridResult,EvalMax) :-
    %write("Explore minimax IA "), nl,
    all_possible_moves(Player, Grid, AllMoves),
    tryMoveIA(Grid,Depth,Player,AllMoves,GridResult,EvalMax).

% Ideam que tryMax mais pour l'adversaire (minimizing)
tryMini(Grid, Depth, Player, GridResult, EvalMin) :-
   endGame(Grid),
   Depth=0,
   tryMini(Grid, Depth, Player, GridResult, EvalMin).
tryMini(Grid, Depth, Player,GridResult,EvalMin) :-
    depthReached(Depth),
    %write("Depth other ="), write(Depth), nl,
    miniHeuristic(GridResult,EvalMin,Grid,Player).
tryMini(Grid, Depth, Player,GridResult,EvalMin) :-
    %write("Explore minimax Other "), nl,
    all_possible_moves(Player, Grid, AllMoves),
    tryMoveOther(Grid,Depth,Player,AllMoves,GridResult,EvalMin).

%Générer arbre avec toutes les coordonnées des coups valides
all_possible_moves(Player, Grid, AllMoves) :-
   %write("Tous les coups possibles pour "), write(Player),
   findall([Line, Column], isValidMove(Grid,Line,Column,Player),
   AllMoves).
   %write(" sont "), write(AllMoves), nl.

% On essaie tous les move possibles
tryMoveIA(Grid,Depth,Player,[],GridResult,EvalMax). %write("allMoves ia done"),nl.
tryMoveIA(Grid,Depth,Player,[[Line,Col]|RemainingMoves],GridResult,EvalMax) :-
    % pour chaque move on l'exécute puis on fait un minimax sur la nouvelle grille obtenue
    %write("test Move ia : "), write(Line), write(Col), write(" Remaining :"), write(RemainingMoves), nl,
    doMove(Grid,Line,Col,Player,NewGrid),
    nextPlayer(Player,NextPlayer),
    NewDepth is Depth-1,
    mini(NewGrid, NewDepth, NextPlayer, GridResultOfMini, 61),
    % on ajoute la grille enfant retenue par l'algo mini de l'enfant
    %write("On regarde si la grille résultat de mini est max pour l'IA"),nl,
    maxHeuristic(GridResult,EvalMax,GridResultOfMini,Player),
    tryMoveIA(Grid, Depth, Player, RemainingMoves, GridResult,EvalMax).

tryMoveOther(Grid,Depth,Player,[],GridResult,EvalMin) :- write("allMoves other done"), nl.
tryMoveOther(Grid,Depth,Player,[[Line,Col]|RemainingMoves],GridResult,EvalMin) :-
    % pour chaque move on l'exécute puis on fait un minimax sur la nouvelle grille obtenue
    %write("test Move other : "), write(Line), write(Col), write(" Remaining :"), write(RemainingMoves), nl,
    doMove(Grid,Line,Col,Player,NewGrid),
    nextPlayer(Player,NextPlayer),
    NewDepth is Depth-1,
    max(NewGrid, NewDepth, NextPlayer,GridResultOfMax,-61),
    % on ajoute la grille enfant retenue par l'algo max de l'enfant
    %write("On regarde si la grille résultat de mini est max pour l'IA"),
    miniHeuristic(GridResult,EvalMin,GridResultOfMax,Player),
    tryMoveOther(Grid, Depth, Player,RemainingMoves,GridResult,EvalMin).

evaluateH1Max(Grid,Player,Eval) :-
    countTokens(Grid, Player, 0, NbTokensIA),
    nextPlayer(Player,Next),
    countTokens(Grid, Next, 0, NbTokensOther),
    Eval is NbTokensIA-NbTokensOther.
evaluateH1Min(Grid,Player,Eval) :-
    countTokens(Grid, Player, 0, NbTokensOther),
    nextPlayer(Player,Next),
    countTokens(Grid, Next, 0, NbTokensIA),
    Eval is NbTokensIA-NbTokensOther.

depthReached(Depth) :-  Depth==0.



