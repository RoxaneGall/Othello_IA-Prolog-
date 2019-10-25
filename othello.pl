% Initiatisation

play() :-  nl,
    write("PLAYER1 (x):"), nl, 
    choosePlayer(Player1), nl,
    write("PLAYER2 (o):"), nl, 
    choosePlayer(Player2), nl,
    write(" -> "), 
    write(Player1),
    write(" vs "),
    write(Player2), nl,
    initialGrid(Grid),
    displayGrid(Grid,x),
    play(Grid,x,Player1,Player2).

choosePlayer(Player) :- tryChoosePlayer(Player).

tryChoosePlayer(Player) :- write("Choisissez la nature du joueur (choix possibles: humain, firstMove) "), read(Player), player(Player).
tryChoosePlayer(Player) :- write("Player inconnu, "), tryChoosePlayer(Player).

player(humain).
player(firstMove).

% Ex�cution d'un tour de jeu

% Cas o� le jeu est fini : endGame(grid, player) v�rifie si le plateau
% complet ou si le joueur n'a plus de jeton
% announce(player) annonce le gagnant.
%play(Grid, CurrentPlayer, Player1, Player2) :- endGame(Grid, Player), !, announce(Player).
play(Grid, Player, humain, Player2) :-
    chooseMove(Grid,Line,Column,Player), 
    doMove(Grid,Line,Column,Player,NewGrid), 
    nextPlayer(Player,NextPlayer), 
    displayGrid(NewGrid,NextPlayer), !, 
    play(NewGrid,NextPlayer,Player2,humain).

play(Grid, Player, firstMove, Player2) :-
    existingMove(Line,Column), 
    isValidMove(Grid,Line,Column,Player),
    doMove(Grid,Line,Column,Player,NewGrid), 
    nextPlayer(Player,NextPlayer), 
    displayGrid(NewGrid,NextPlayer), !, 
    play(NewGrid,NextPlayer,Player2,firstMove).

% Passage au joueur oppos�
nextPlayer(x,o).
nextPlayer(o,x).

% Pr�dicat pour v�rifier si le mouvement est valide
% existingMove(l,c) v�rifie que ligne et colonne rentr�es sont comprises
% dans [a,h] et [1,8]
% isValidMove(grid,line,col,player) v�rifier 2 choses : que la place
% choisie est libre (pas d'autre jeton) et que poser son jeton ici
% permet au player de manger des jetons adverses
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

% Conditions de fin du jeu endGame(grid, player) :- A FAIRE PAR LES
% MOCHES

% Les mouvements possibles
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

existingMove(Number,Column) :-
    existingPosition(Number),
    existingPosition(Column).

existingMove(Number,Letter,Number,Column) :-
    existingPosition(Number),
    letterToNum(Letter,Column),
    existingPosition(Column).

