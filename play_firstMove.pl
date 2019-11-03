% Premier coup possible trouvé

firstMove(Token,Grid,Line,Column) :- 
    existingMove(Line,Column),
    isValidMove(Grid,Line,Column,Token).
