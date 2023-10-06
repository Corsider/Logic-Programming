# Отчет по ЛР3
## Барсуков Егор М8О-310Б-21
# Применение Prolog для решения задач поиска в пространстве состояний

# Задача:
Крестьянину нужно переправить волка, козу и капусту с левого берега реки на правый. Как это сделать за минимальное число шагов, если в распоряжении крестьянина имеется двухместная лодка, и нельзя оставлять волка и козу или козу и капусту вместе без присмотра человека

# Решение
Создаем правила для противоречий, добавляем предикаты инкрементирования, вывода результатов вычислений на экран.
```prolog
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
```
Предикаты move нужны для обхода графа. Здесь происходит перемещение объектов:
```prolog
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
```
Предикаты, реализующие алгоритмы поиска в глубину (DFS), в ширину (BFS) и итеративного погружения.
```prolog
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
```
# Проверка работы алгоритмов
Теперь проверим работу. Запустим по очереди DFS, BFS и итеративный алгоритмы:
```
1 ?- searchDFS(s([volk, koza, kapusta], 'L', []), s([], 'R', [_,_,_])). ;;
Start
s([volk,koza,kapusta],L,[])
s([volk,kapusta],R,[koza])
s([volk,kapusta],L,[koza])
s([kapusta],R,[koza,volk])
s([kapusta,koza],L,[volk])
s([koza],R,[volk,kapusta])
s([koza],L,[volk,kapusta])
s([],R,[volk,kapusta,koza])
End

Time spent 0.00685882568359375

true ;
s([volk,koza,kapusta],L,[])
s([volk,kapusta],R,[koza])
s([volk,kapusta],L,[koza])
s([kapusta],R,[koza,volk])
s([kapusta,koza],L,[volk])
s([kapusta],R,[volk,koza])
s([kapusta,volk],L,[koza])
s([volk],R,[koza,kapusta])
s([volk,koza],L,[kapusta])
s([koza],R,[kapusta,volk])
s([koza],L,[kapusta,volk])
s([],R,[kapusta,volk,koza])
End

Time spent 0.009544849395751953

true ;
s([volk,koza,kapusta],L,[])
s([volk,kapusta],R,[koza])
s([volk,kapusta],L,[koza])
s([volk],R,[koza,kapusta])
s([volk,koza],L,[kapusta])
s([koza],R,[kapusta,volk])
s([koza],L,[kapusta,volk])
s([],R,[kapusta,volk,koza])
End

Time spent 0.011195898056030273

true .
```
```
2 ?- searchBFS(s([volk, koza, kapusta], 'L', []), s([], 'R', [_,_,_])). ;; 
Start
s([volk,koza,kapusta],L,[])
s([volk,kapusta],R,[koza]) 
s([volk,kapusta],L,[koza]) 
s([kapusta],R,[koza,volk]) 
s([kapusta,koza],L,[volk]) 
s([koza],R,[volk,kapusta]) 
s([koza],L,[volk,kapusta]) 
s([],R,[volk,kapusta,koza])
End

Time spent 0.001146078109741211

true ;
s([volk,koza,kapusta],L,[])
s([volk,kapusta],R,[koza])
s([volk,kapusta],L,[koza])
s([volk],R,[koza,kapusta])
s([volk,koza],L,[kapusta])
s([koza],R,[kapusta,volk])
s([koza],L,[kapusta,volk])
s([],R,[kapusta,volk,koza])
End

Time spent 0.002824068069458008

true ;
s([volk,koza,kapusta],L,[])
s([volk,kapusta],R,[koza])
s([volk,kapusta],L,[koza])
s([kapusta],R,[koza,volk])
s([kapusta,koza],L,[volk])
s([kapusta],R,[volk,koza])
s([kapusta,volk],L,[koza])
s([volk],R,[koza,kapusta])
s([volk,koza],L,[kapusta])
s([koza],R,[kapusta,volk])
s([koza],L,[kapusta,volk])
s([],R,[kapusta,volk,koza])
End

Time spent 0.0042459964752197266

true .
```
```
3 ?- searchIter(s([volk, koza, kapusta], 'L', []), s([], 'R', [_,_,_])). ;; 
Start
s([volk,koza,kapusta],L,[])
s([volk,kapusta],R,[koza])
s([volk,kapusta],L,[koza])
s([kapusta],R,[koza,volk])
s([kapusta,koza],L,[volk])
s([koza],R,[volk,kapusta])
s([koza],L,[volk,kapusta])
s([],R,[volk,kapusta,koza])
End

Time spent 0.001216888427734375

true ;
s([volk,koza,kapusta],L,[])
s([volk,kapusta],R,[koza])
s([volk,kapusta],L,[koza])
s([volk],R,[koza,kapusta])
s([volk,koza],L,[kapusta])
s([koza],R,[kapusta,volk])
s([koza],L,[kapusta,volk])
s([],R,[kapusta,volk,koza])
End

Time spent 0.0030989646911621094

true ;
s([volk,koza,kapusta],L,[])
s([volk,kapusta],R,[koza])
s([volk,kapusta],L,[koza])
s([kapusta],R,[koza,volk])
s([kapusta,koza],L,[volk])
s([kapusta],R,[volk,koza])
s([kapusta,volk],L,[koza])
s([volk],R,[koza,kapusta])
s([volk,koza],L,[kapusta])
s([koza],R,[kapusta,volk])
s([koza],L,[kapusta,volk])
s([],R,[kapusta,volk,koza])
End

Time spent 0.0049228668212890625

true .
```
# Вывод
По результатам тестов видно, что все 3 алгоритма справились со своей задачей. Самыми эффективными оказались итеративный и поиск в глубину. Поиск в ширину так же находит в конце более длинные маршруты, чем в начале.


















