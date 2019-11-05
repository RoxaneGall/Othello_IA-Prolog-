:- dynamic(cache/2).

set(Key, _) :-
  delete(Key, _),
  fail.

set(Key,Data) :-
  assert(cache(Key, Data)).

delete(Key,_) :-
  retractall(cache(Key,_)).

get(Key, Data) :-
  cache(Key, Data).