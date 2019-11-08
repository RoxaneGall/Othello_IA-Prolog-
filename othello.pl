:- consult('./grid.pl').
:- consult('./play_firstMove.pl').
:- consult('./play_aleatoire.pl').
:- consult('./play_humain.pl').
:- consult('./play_minmax.pl').
:- consult('./play_alphaBeta.pl').
:- consult('./stats.pl').
:- consult('./heuristic.pl').

:- set_prolog_flag(stack_limit, 14 000 000 000). %Pour le developpement, et la recherche en profondeur D=5.


% Initialisation
play() :-
    choosePlayers(Player1,Player2),
    set(x,0),
    set(o,0),
    play(Player1,Player2).

play(Player1,Player2) :-
    initialGrid(Grid),
    displayGrid(Grid,x),
    play(Grid,x,Player1,Player2).

choosePlayers(Player1,Player2) :-
    nl, write("Player1 (x):"), nl,
    tryChoosePlayer(Player1), nl,
    write("Player2 (o):"), nl,
    tryChoosePlayer(Player2), nl,
    write(" -> "),
    write(Player1),
    write(" vs "),
    write(Player2), nl.

tryChoosePlayer(Player) :- write("Choisissez la nature du joueur (choix possibles: humain, firstMove, aleatoire, mMCountTokens, mMCountMoves, mMCountCorners, mMStabilite, mMGlobal, aBCountTokens, aBCountMoves, aBCountCorners, aBStabilite, aBGlobal) :"), read(Player), player(Player).
tryChoosePlayer(Player) :- write("Player inconnu ! "), tryChoosePlayer(Player).

%Tous les modes de jeu possible
player(humain).
player(firstMove).
player(aleatoire).
player(mMCountTokens).
player(mMCountMoves).
player(mMCountCorners).
player(mMStabilite).
player(mMGlobal).
player(aBCountTokens).
player(aBCountMoves).
player(aBCountCorners).
player(aBStabilite).
player(aBGlobal).

% Execution d'un tour de jeu

% Generiser les play et mettre les differents modes de jeux dans des
% fichiers separes

%Verifier que le jeu n'est pas termine
play(Grid, CurrentToken, CurrentPlayerNature, NextPlayerNature) :-
    endGame(Grid),
    announceWinner(Grid, CurrentToken, CurrentPlayerNature, NextPlayerNature).

%Jouer un tour en fonction de la nature du joueur actuel
play(Grid, CurrentToken, CurrentPlayerNature, NextPlayerNature) :-
    canMove(Grid, CurrentToken),
    moveToDo(CurrentPlayerNature,CurrentToken,Grid,Line,Column),
    doMove(Grid,Line,Column,CurrentToken,NewGrid),
    nextPlayer(CurrentToken,NextToken),
    displayGrid(NewGrid,NextToken),
    play(NewGrid,NextToken,NextPlayerNature,CurrentPlayerNature).

%Passer son tour si le joueur ne peut pas jouer
play(Grid, CurrentToken, CurrentPlayerNature, NextPlayerNature) :-
    nextPlayer(CurrentToken,NextToken),
    write(CurrentPlayerNature), write(" ("), write(CurrentToken), write(") PASSE SON TOUR!"), nl,
    play(Grid,NextToken,NextPlayerNature,CurrentPlayerNature).

% Choix du coup à faire selon la nature du joueur
moveToDo(humain,Token,Grid,Line,Column) :- humain(Token,Grid,Line,Column).
moveToDo(aleatoire,Token,Grid,Line,Column) :- aleatoire(Token,Grid,Line,Column).
moveToDo(firstMove,Token,Grid,Line,Column) :- firstMove(Token,Grid,Line,Column).
moveToDo(mMCountTokens,Token,Grid,Line,Column) :- minmax(countTokens,Token,3,Grid,Token,(Line,Column)).
moveToDo(mMCountMoves,Token,Grid,Line,Column) :- minmax(countMoves,Token,3,Grid,Token,(Line,Column)).
moveToDo(mMCountCorners,Token,Grid,Line,Column) :- minmax(countCorners,Token,3,Grid,Token,(Line,Column)).
moveToDo(mMStabilite,Token,Grid,Line,Column) :- minmax(stabilite,Token,3,Grid,Token,(Line,Column)).
moveToDo(mMGlobal,Token,Grid,Line,Column) :- minmax(global,Token,3,Grid,Token,(Line,Column)).
moveToDo(aBCountTokens,Token,Grid,Line,Column) :- alphaBeta(countTokens,Token,3,Grid,Token,(Line,Column)).
moveToDo(aBCountMoves,Token,Grid,Line,Column) :- alphaBeta(countMoves,Token,3,Grid,Token,(Line,Column)).
moveToDo(aBCountCorners,Token,Grid,Line,Column) :- alphaBeta(countCorners,Token,3,Grid,Token,(Line,Column)).
moveToDo(aBStabilite,Token,Grid,Line,Column) :- alphaBeta(stabilite,Token,3,Grid,Token,(Line,Column)).
moveToDo(aBGlobal,Token,Grid,Line,Column) :- alphaBeta(global,Token,3,Grid,Token,(Line,Column)).

% Passage au joueur oppose
nextPlayer(x,o).
nextPlayer(o,x).

%
canMove(Grid, Token) :-
    existingMove(Line,Column),
    isValidMove(Grid,Line,Column,Token).

% Conditions de fin du jeu endGame(Grid)
endGame(Grid) :-
    \+ canMove(Grid,o),
    \+ canMove(Grid,x).

% Les mouvements possibles : letterToNum permet de convertir une lettre
% en chiffre
letterToNum(a,1).
letterToNum(b,2).
letterToNum(c,3).
letterToNum(d,4).
letterToNum(e,5).
letterToNum(f,6).
letterToNum(g,7).
letterToNum(h,8).

existingPosition(1).
existingPosition(2).
existingPosition(3).
existingPosition(4).
existingPosition(5).
existingPosition(6).
existingPosition(7).
existingPosition(8).

% existingMove(l,c) verifie que ligne et colonne rentrees sont
% comprises dans [a,h] et [1,8]
existingMove(Number,Column) :-
    existingPosition(Number),
    existingPosition(Column).

existingMove(Number,Letter,Number,Column) :-
    existingPosition(Number),
    letterToNum(Letter,Column),
    existingPosition(Column).

