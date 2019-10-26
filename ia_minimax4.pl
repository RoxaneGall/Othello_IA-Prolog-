%ia_minimax4(Grid, Player, Player2, Line, Column) :- 
%	Depth \= 0, 
%	\endGame(grid).


%Générer arbre avec tous les coordonnés des coups coups valides 
all_possible_moves(Player, Grid, AllMoves, FinalGrid) :- findall([Line, Column], isValidMove(Grid,Line,Column,Player), AllMoves).
