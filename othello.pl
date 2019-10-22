% Initiatisation

initGame() :-  player=x,initialGrid(),displayGrid(grid,player),play(grid,player).

% Exécution d'un tour de jeu

% Cas où le jeu est fini : endGame(grid, player) vérifie si le plateau
% complet ou si le joueur n'a plus de jeton
% announce(player) annonce le gagnant.
play(grid, player) :- endGame(grid, player), !, announce(player).
play(grid, player) :- chooseMove(grid,line,col,player), doMove(grid,line,col,player,newGrid), displayGrid(newGrid,player), nextPlayer(player,player2), !, play(newGrid,player2). % cas d'un tour classique

% Passage au joueur opposé
nextPlayer(x,o).
nextPlayer(o,x).

% Prédicat pour vérifier si le mouvement est valide
% existingMove(l,c) vérifie que ligne et colonne rentrées sont comprises
% dans [a,h] et [1,8]
% isValidMove(grid,line,col,player) vérifier 2 choses : que la place
% choisie est libre (pas d'autre jeton) et que poser son jeton ici
% permet au player de manger des jetons adverses
chooseMove(grid,line,col,player) :- existingMove(line,col), isValidMove(grid,line,col,player), !.


% Conditions de fin du jeu endGame(grid, player) :- A FAIRE PAR LES
% MOCHES

% Les mouvements possibles
existingMove(a,1).
existingMove(a,2).
existingMove(a,3).
existingMove(a,4).
existingMove(a,5).
existingMove(a,6).
existingMove(a,7).
existingMove(a,8).
existingMove(b,1).
existingMove(b,2).
existingMove(b,3).
existingMove(b,4).
existingMove(b,5).
existingMove(b,6).
existingMove(b,7).
existingMove(b,8).
existingMove(c,1).
existingMove(c,2).
existingMove(c,3).
existingMove(c,4).
existingMove(c,5).
existingMove(c,6).
existingMove(c,7).
existingMove(c,8).
existingMove(e,1).
existingMove(e,2).
existingMove(e,3).
existingMove(e,4).
existingMove(e,5).
existingMove(e,6).
existingMove(e,7).
existingMove(e,8).
existingMove(f,1).
existingMove(f,2).
existingMove(f,3).
existingMove(f,4).
existingMove(f,5).
existingMove(f,6).
existingMove(f,7).
existingMove(f,8).
existingMove(g,1).
existingMove(g,2).
existingMove(g,3).
existingMove(g,4).
existingMove(g,5).
existingMove(g,6).
existingMove(g,7).
existingMove(g,8).
existingMove(h,1).
existingMove(h,2).
existingMove(h,3).
existingMove(h,4).
existingMove(h,5).
existingMove(h,6).
existingMove(h,7).
existingMove(h,8).





