% Jeu Humain

humain(Token,Grid,Line,Column) :- tryChooseMove(Grid,Line,Column,Token).

tryChooseMove(Grid,Line,Column,Token) :-
    write("Entrez la lettre de la case choisie "),
    read(Letter),
    write("Entrez le numero de la case choisie "),
    read(Number),
    existingMove(Number,Letter,Line,Column),
    isValidMove(Grid,Line,Column,Token), !.

tryChooseMove(Grid,Line,Column,Token) :-
    write("Position illegale, "),
    tryChooseMove(Grid,Line,Column,Token).