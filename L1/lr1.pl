% 1. Предикаты обработки списков
% ВАРИАНТ 1

% Предикат длины списка
mylength([], 0).
mylength([_|T], L) :- mylength(T, L1), L is L1 + 1.

% Предикат принадлежности элемента списку
mymember(X, [X|T]).
mymember(X, [H|T]) :- mymember(X,T).

% Предикат конкатенации списков
myappend([], X, X).
myappend([H|T], Y, [H|X]) :- myappend(T, Y, X).

% Предикат удаления элемента
myremove(X, [H|T], [H|Y]) :- myremove(X, T, Y).
myremove(X, [X|T], T).

% Перестановка
mypermute([],[]).
mypermute(S, [L|Y]) :- myremove(L, S, X), mypermute(X, Y).

% Подсписок
mysublist(X,Y) :- myappend(A,B,C), myappend(X,A,B).




% Получение последнего элемента списка (вариант 1)
getLastElem(L, X) :- append(_, [X], L).

% Без встроенных предикатов:
getLastElemN([X], X).
getLastElemN([_|L], X) :- getLastElemN(L, X).

% Сумма
mysum([], 0).
mysum([X|T], N) :- mysum(T, N1), N is N1 + X.



%  Совместное использование предикатов. Вычисление длины, последнего элемента и суммы
do(L, LEN, LAST, SUM) :- mylength(L, LEN), getLastElem(L, LAST), mysum(L, SUM).
