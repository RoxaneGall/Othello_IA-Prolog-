%ia_minimax4(Grid, Player, Player2, Line, Column) :-
%	Depth \= 0,
%	\endGame(grid).


%Genrer arbre avec toutes les coordonnees des coups valides
all_possible_moves(Player, Grid, AllMoves, FinalGrid) :- findall([Line, Column], isValidMove(Grid,Line,Column,Player), AllMoves).
