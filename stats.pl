
stats(NbOfRounds) :- 
    choosePlayers(Player1,Player2),
    stats(NbOfRounds,0,Player1,Player2,0,0).

stats(NbOfRounds,NbOfRoundsDone,Player1,Player2,Player1NbOfRoundsWon,Player2NbOfRoundsWon) :-
    NbOfRounds \== NbOfRoundsDone,
    NextNbOfRoundsDone is NbOfRoundsDone+1,
    initialGrid(Grid),
    playStats(Grid,x,Player1,Player2,Winner),
    addStats(Winner,Player1NbOfRoundsWon,Player2NbOfRoundsWon,NextPlayer1NbOfRoundsWon,NextPlayer2NbOfRoundsWon),
    stats(NbOfRounds,NextNbOfRoundsDone,Player1,Player2,NextPlayer1NbOfRoundsWon,NextPlayer2NbOfRoundsWon).

stats(NbOfRounds,_,Player1,Player2,Player1NbOfRoundsWon,Player2NbOfRoundsWon) :-
    Rate1 is 100*(Player1NbOfRoundsWon/NbOfRounds),
    Rate2 is 100*(Player2NbOfRoundsWon/NbOfRounds),
    nl,write(Player1),write(" (x) : "),write(Rate1),write(' % de reussite'),
    nl,write(Player2),write(" (o) : "),write(Rate2),write(' % de reussite').

addStats(x,Player1NbOfRoundsWon,Player2NbOfRoundsWon,NextPlayer1NbOfRoundsWon,Player2NbOfRoundsWon) :- NextPlayer1NbOfRoundsWon is Player1NbOfRoundsWon+1.
addStats(o,Player1NbOfRoundsWon,Player2NbOfRoundsWon,Player1NbOfRoundsWon,NextPlayer2NbOfRoundsWon) :- NextPlayer2NbOfRoundsWon is Player2NbOfRoundsWon+1.
addStats(_,Player1NbOfRoundsWon,Player2NbOfRoundsWon,NextPlayer1NbOfRoundsWon,NextPlayer2NbOfRoundsWon) :- 
    NextPlayer1NbOfRoundsWon is Player1NbOfRoundsWon+1,
    NextPlayer2NbOfRoundsWon is Player2NbOfRoundsWon+1.
    

%Verifier que le jeu n'est pas termine
playStats(Grid, _, _, _, Winner) :-
    endGame(Grid),
    countTokens(Grid, x, 0, Nx),
    countTokens(Grid, o, 0, No),
    winner(Nx,No,Winner).

%cas ou pas de gagnant
playStats(Grid, _, _, _, null) :-
    endGame(Grid).

%Jouer un tour en fonction de la nature du joueur actuel
playStats(Grid, CurrentToken, CurrentPlayerNature, NextPlayerNature, Winner) :-
    canMove(Grid, CurrentToken),
    moveToDo(CurrentPlayerNature,CurrentToken,Grid,Line,Column),
    doMove(Grid,Line,Column,CurrentToken,NewGrid),
    nextPlayer(CurrentToken,NextToken),
    playStats(NewGrid,NextToken,NextPlayerNature,CurrentPlayerNature, Winner).

%Passer son tour si le joueur ne peut pas jouer
playStats(Grid, CurrentToken, CurrentPlayerNature, NextPlayerNature, Winner) :-
    nextPlayer(CurrentToken,NextToken),
    playStats(Grid,NextToken,NextPlayerNature,CurrentPlayerNature, Winner).
