initialGrid([
[" ", "A", "B", "C", "D", "E", "F", "G", "H"],
["1", "-", "-", "-", "-", "-", "-", "-", "-"],
["2", "-", "-", "-", "-", "-", "-", "-", "-"],
["3", "-", "-", "-", "-", "-", "-", "-", "-"],
["4", "-", "-", "-", o,   x,   "-", "-", "-"],
["5", "-", "-", "-", x,   o,   "-", "-", "-"],
["6", "-", "-", "-", "-", "-", "-", "-", "-"],
["7", "-", "-", "-", "-", "-", "-", "-", "-"],
["8", "-", "-", "-", "-", "-", "-", "-", "-"]
]).

displayGrid(Grid,Player) :-
    length(Grid,Nblines),
    nl, write("  AU TOUR DE : "), write(Player), nl, nl,
    forall(between(1, Nblines, Line), (nth1(Line,Grid,CharList), displayRow(CharList), nl)),
    nl.


displayRow(CharList) :- 
    length(CharList,Nbcol),
    write("  "),
    forall(between(1, Nbcol, Col),(nth1(Col,CharList,Char), write(Char), write(" "))). 
