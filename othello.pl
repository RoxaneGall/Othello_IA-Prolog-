% Initialisation

play() :-  nl,
    write("PLAYER1 (x):"), nl,
    tryChoosePlayer(Player1), nl,
    write("PLAYER2 (o):"), nl,
    tryChoosePlayer(Player2), nl,
    write(" -> "),
    write(Player1),
    write(" vs "),
    write(Player2), nl,
    play(Player1,Player2).

play(Player1,Player2) :-
    initialGrid(Grid),
    displayGrid(Grid,x),
    play(Grid,x,Player1,Player2).

tryChoosePlayer(Player) :- write("Choisissez la nature du joueur (choix possibles: humain, firstMove, aleatoire, minimax) :"), read(Player), player(Player).
tryChoosePlayer(Player) :- write("Player inconnu ! "), tryChoosePlayer(Player).

player(humain).
player(firstMove).
player(aleatoire).
player(minimax).

% Execution d'un tour de jeu

% Cas où le jeu est fini :
% endGame(grid, player) verifie si le plateau est complet, si le joueur
% n'a plus de jeton ou s'il n'a pas de coup possible
% announce(player) annonce le gagnant.

% Generiser les play et mettre les differents modes de jeux dans des
% fichiers separes

play(Grid, CurrentPlayer, Player1, Player2) :-
    endGame(Grid),
    announceWinner(Grid, CurrentPlayer, Player1, Player2), !.

play(Grid, Player, humain, Player2) :-
    canMove(Grid, Player),
    chooseMove(Grid,Line,Column,Player),
    doMove(Grid,Line,Column,Player,NewGrid),
    nextPlayer(Player,NextPlayer),
    displayGrid(NewGrid,NextPlayer), !,
    play(NewGrid,NextPlayer,Player2,humain).

%IA qui effectue le premier mouvement possible
play(Grid, Player, firstMove, Player2) :-
    existingMove(Line,Column),
    isValidMove(Grid,Line,Column,Player),
    doMove(Grid,Line,Column,Player,NewGrid),
    nextPlayer(Player,NextPlayer),
    displayGrid(NewGrid,NextPlayer), !,
    play(NewGrid,NextPlayer,Player2,firstMove).

%IA qui effectue un mouvement aleatoire
play(Grid, Player, aleatoire, Player2) :-
    canMove(Grid, Player), %s'assure qu'il existe un mouvement possible
    chooseRandomMove(Grid, Player, Line, Column),
    doMove(Grid,Line,Column,Player,NewGrid),
    nextPlayer(Player,NextPlayer),
    displayGrid(NewGrid,NextPlayer), !,
    play(NewGrid,NextPlayer,Player2,aleatoire).

%IA en profondeur
play(Grid, Player, minimax, Player2) :-
    canMove(Grid, Player), %s'assure qu'il existe un mouvement possible
    max(Grid, 3, Player,NewGrid,-65), % 1 est la profondeur pour laquelle on exécute l'algo miniMax
    nextPlayer(Player,NextPlayer),
    displayGrid(NewGrid,NextPlayer), !,
    play(NewGrid,NextPlayer,Player2,minimax).

%Passer son tour
play(Grid, Player, Player1, Player2) :-
    nextPlayer(Player,NextPlayer),
    write(Player1), write(" ("), write(Player), write(") PASSE SON TOUR!"), nl,
    play(Grid,NextPlayer,Player2,Player1).

%Choisi un mouvement Random en supposant qu'il en existe un
chooseRandomMove(Grid, Player, Line, Column) :-
    repeat,
	random(1,9,Line),
	random(1,9, Column),
	existingMove(Line,Column),
    isValidMove(Grid,Line,Column,Player).

% Passage au joueur oppose
nextPlayer(x,o).
nextPlayer(o,x).

%
canMove(Grid, Player) :-
    existingMove(Line,Column),
    isValidMove(Grid,Line,Column,Player).

% Conditions de fin du jeu endGame(Grid)
endGame(Grid) :-
    \+ canMove(Grid,o),
    \+ canMove(Grid,x).


chooseMove(Grid,Line,Column,Player) :- tryChooseMove(Grid,Line,Column,Player).

tryChooseMove(Grid,Line,Column,Player) :-
    write("Entrez la lettre de la case choisie "),
    read(Letter),
    write("Entrez le numero de la case choisie "),
    read(Number),
    existingMove(Number,Letter,Line,Column),
    isValidMove(Grid,Line,Column,Player), !.

tryChooseMove(Grid,Line,Column,Player) :-
    write("Position illegale, "),
    tryChooseMove(Grid,Line,Column,Player).


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

