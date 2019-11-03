% Coup aléatoire possible dans la grille

%Choisi un mouvement Random en supposant qu'il en existe un
aleatoire(Token,Grid,Line,Column) :- 
    repeat,
	random(1,9,Line),
	random(1,9, Column),
	existingMove(Line,Column),
    isValidMove(Grid,Line,Column,Token).