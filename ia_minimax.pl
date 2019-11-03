% IA MINI MAX
%
% Fonctionnement de l'algo : https://www.youtube.com/watch?v=l-hh51ncgDI
%
% Grid est la grille sur laquelle l'IA doit jouer
%
% Depth est la profondeur c�d le nb de tours futurs pour lesquels on va
% �valuer tous les coups possibles afin d'optimiser ce que l'IA doit
% jouer
%
% Player est au d�part le joueur correspondant � l'IA, puis il
% repr�sente l'autre joueur quand on �value le coup de l'adversaire
% et ainsi de suite
%
% GridResult est la grille r�sultant du coup choisi par l'IA (ou du coup
% choisi par l'adversaire)
%
% Eval est l'heuristique, qui repr�sente ici le nombre de pions de
% diff�rence entre le joueur IA et le joueur adverse (par exemple si
% l'IA a 15 pions et l'adversaire 11 : eval = 4 ; si l'IA a 2 pions et
% l'adversaire 10 : eval = -8). L'Eval min est initialis�e � -65 et
% l'Eval max � 65.

% max : d�but de l'algo d'�valuation du meilleur coup � jouer pour
% l'IA
max(Grid, Depth, Player, GridResult,EvalMax) :-
    %write(" tryMax "), nl,
    tryMax(Grid, Depth, Player,GridResult,EvalMax), !.

% si le jeu est fini
% on dit que la profondeur est de 0
tryMax(Grid, Depth, Player, GridResult, EvalMax) :-
   endGame(Grid),
   Depth=0,
   tryMax(Grid, Depth, Player, GridResult,EvalMax).
% si la profondeur est de 0
% on �value l'�tat de la grille en param�tre : Eval correspond �
% l'heuristique
tryMax(Grid, 0, Player,GridResult,EvalMax) :-
    %write("Depth ia ="), write(Depth), nl,
    maxHeuristic(GridResult,EvalMax,Grid,Player).
% sinon on ex�cute l'algo
% cas o� on �value pour l'ia (maximizing)
tryMax(Grid, Depth, Player,GridResult,EvalMax) :-
    %write("Explore minimax IA "), nl,
    all_possible_moves(Player, Grid, AllMoves),
    tryMoveIA(Grid,Depth,Player,AllMoves,GridResult,EvalMax).

% On essaie tous les move possibles
tryMoveIA(Grid,Depth,Player,[],GridResult,EvalMax). %write("allMoves ia done"),nl.
tryMoveIA(Grid,Depth,Player,[[Line,Col]|RemainingMoves],GridResult,EvalMax) :-
    % pour chaque move on l'ex�cute puis on fait un minimax sur la nouvelle grille obtenue
    %write("test Move ia : "), write(Line), write(Col), write(" Remaining :"), write(RemainingMoves), nl,
    doMove(Grid,Line,Col,Player,NewGrid),
    nextPlayer(Player,NextPlayer),
    NewDepth is Depth-1,
    mini(NewGrid, NewDepth, NextPlayer, GridResultOfMini, 65),
    % on ajoute la grille enfant retenue par l'algo mini de l'enfant
    %write("On regarde si la grille r�sultat de mini est max pour l'IA"),nl,
    maxHeuristic(GridResult,EvalMax,GridResultOfMini,Player),
    tryMoveIA(Grid, Depth, Player, RemainingMoves, GridResult,EvalMax).


% maxHeuristic fait que GridResult est toujours la grille max
maxHeuristic(GridResult,EvalMax,GridResult,Player).
maxHeuristic(GridResult,EvalMax,Grid,Player) :-
    evaluateH1Max(Grid,Player,Eval),
    getMax(GridResult,EvalMax,Grid,Eval,Player),!.

evaluateH1Max(Grid,Player,Eval) :-
    countTokens(Grid, Player, 0, NbTokensIA),
    nextPlayer(Player,Next),
    countTokens(Grid, Next, 0, NbTokensOther),
    Eval is NbTokensIA-NbTokensOther.

getMax(GridResult,EvalMax,Grid,Eval,Player) :-
    Eval =< EvalMax.
    % write("La grille �valu�e a une eval="),write(Eval), write(" inf�rieur � l'eval max")
getMax(GridResult,EvalMax,Grid,Eval,Player) :-
    Eval>EvalMax,
    % write("L'eval est sup�rieur � l'evalMax. "),
    maxHeuristic(Grid,Eval,Grid,Player). % on remplace GridResult par Grid et EvalMax par Eval
    %write("La grille max est celle d'eval="), write(Eval), nl

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mini(Grid, Depth, Player, GridResult,EvalMin) :-
    %write(" tryMini "), nl,
    %NextPossibleGrids correspond aux enfant du noeud Other, on ajoutera au fur et � mesure les grilles enfants avec leur eval d'heuristique
    tryMini(Grid, Depth, Player, GridResult, EvalMin), !.

% Ideam que tryMax mais pour l'adversaire (minimizing)
tryMini(Grid, Depth, Player, GridResult, EvalMin) :-
   endGame(Grid),
   Depth=0,
   tryMini(Grid, Depth, Player, GridResult, EvalMin).
tryMini(Grid, 0, Player,GridResult,EvalMin) :-
    %write("Depth other ="), write(Depth), nl,
    miniHeuristic(GridResult,EvalMin,Grid,Player).
tryMini(Grid, Depth, Player,GridResult,EvalMin) :-
    %write("Explore minimax Other "), nl,
    all_possible_moves(Player, Grid, AllMoves),
    tryMoveOther(Grid,Depth,Player,AllMoves,GridResult,EvalMin).

tryMoveOther(Grid,Depth,Player,[],GridResult,EvalMin). % :- write("allMoves other done"), nl.
tryMoveOther(Grid,Depth,Player,[[Line,Col]|RemainingMoves],GridResult,EvalMin) :-
    % pour chaque move on l'ex�cute puis on fait un minimax sur la nouvelle grille obtenue
    %write("test Move other : "), write(Line), write(Col), write(" Remaining :"), write(RemainingMoves), nl,
    doMove(Grid,Line,Col,Player,NewGrid),
    nextPlayer(Player,NextPlayer),
    NewDepth is Depth-1,
    max(NewGrid, NewDepth, NextPlayer,GridResultOfMax,-65),
    % on ajoute la grille enfant retenue par l'algo max de l'enfant
    %write("On regarde si la grille r�sultat de mini est max pour l'IA"),
    miniHeuristic(GridResult,EvalMin,GridResultOfMax,Player),
    tryMoveOther(Grid, Depth, Player,RemainingMoves,GridResult,EvalMin).

% GridMax est la 1ere grille dont l'eval est maximale
miniHeuristic(GridResult,EvalMin,GridResult,Player).
miniHeuristic(GridResult,EvalMin,Grid,Player) :-
    evaluateH1Min(Grid,Player,Eval),
    getMin(GridResult,EvalMin,Grid,Eval).

evaluateH1Min(Grid,Player,Eval) :-
    countTokens(Grid, Player, 0, NbTokensOther),
    nextPlayer(Player,Next),
    countTokens(Grid, Next, 0, NbTokensIA),
    Eval is NbTokensIA-NbTokensOther.

getMin(GridResult,EvalMin,Grid,Eval) :-
    Eval >= EvalMin.
    %write("La grille �valu�e a une eval sup�rieur � l'eval min").
getMin(GridResult,EvalMin,Grid,Eval) :-
    Eval<EvalMin,
    %write("L'eval est inf�rieure � l'evalMin. "),
    miniHeuristic(Grid,Eval,Grid,Player). % on remplace GridResult par Grid et EvalMin par Eval

% G�n�rer arbre avec toutes les coordonn�es des coups valides
all_possible_moves(Player, Grid, AllMoves) :-
   %write("Tous les coups possibles pour "), write(Player),
   findall([Line, Column], isValidMove(Grid,Line,Column,Player),
   AllMoves).
   %write(" sont "), write(AllMoves), nl.



