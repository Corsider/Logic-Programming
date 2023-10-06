bad(volk, koza).
bad(koza, volk).
bad(kapusta, koza).
bad(koza, kapusta).
checkIfBad([E1, E2]) :- bad(E1, E2).

addToStart(E, [], [E]).
addToStart(E, [H|T], [H|T1]) :- addToStart(E, T, T1).
increment(1).
increment(X) :- increment(Y), X is Y + 1.

printResult([]).
printResult([A|T]) :- printResult(T), write(A), nl.
%
% LEFT (L) bereg CENTER lodka RIGHT (R) bereg 
% move - move along graph
%

% starting at left
move(s([E1, E2, E3], 'L', []), s([E1, E2], 'R', [E3])) :- not(checkIfBad([E1, E2])).
move(s([E1, E2, E3], 'L', []), s([E1, E3], 'R', [E2])) :- not(checkIfBad([E1, E3])).
move(s([E1, E2, E3], 'L', []), s([E2, E3], 'R', [E1])) :- not(checkIfBad([E2, E3])).

% check if can go R -> L
move(s([L|T], 'R', R), s([L|T], 'L', R)) :- not(checkIfBad(R)).
move(s(L, 'R', [E1, E2]), s(RES, 'L', [E2])) :- checkIfBad([E1, E2]), addToStart(E1, L, RES).

% transfering
move(s([L|LT], 'L', [R|RT]), s(LT, 'R', RES)) :- addToStart(L, [R|RT], RES).
move(s([X, L|LT],'L',[R|RT]), s([X|LT], 'R', RES)) :- addToStart(L, [R|RT], RES).

longer([In1|In2], [RES, In1|In2]) :- move(In1, RES), not(member(RES, [In1|In2])).

% DFS
searchDFS(A, B) :- write('Start'), nl, get_time(DFS), dpths([A], B, L), printResult(L), get_time(DFS1), write('End'), nl, nl, T1 is DFS1 - DFS, write('Time spent '), write(T1), nl, nl.
dpths([X|T], X, [X|T]).
dpths(P, F, L) :- longer(P, P1), dpths(P1, F, L).

% BFS
searchBFS(X, Y) :- write('Start'), nl, get_time(BFS), wdths([[X]], Y, L), printResult(L), get_time(BFS1), write('End'), nl, nl, T1 is BFS1 - BFS, write('Time spent '), write(T1), nl, nl.
wdths([[A|T]|_], A, [A|T]).
wdths([H|T1], X, R) :- findall(Z, longer(H, Z), T), append(T1, T, RES), !, wdths(RES, X, R).
wdths([_|T], X, R) :- wdths(T, X, R).

% Iterative
searchIter(S, F) :- write('Start'), nl, get_time(ITER), increment(DepthLimit), dit([S], F, Res, DepthLimit), printResult(Res), get_time(ITER1), write('End'), nl, nl, T1 is ITER1 - ITER, write('Time spent '), write(T1), nl, nl.
dit([F|T], F, [F|T], 0).
dit(Path, F, R, N) :- N > 0, longer(Path, Path1), N1 is N - 1, dit(Path1, F, R, N1).
