# Отчет по ЛР1
## Барсуков Егор М8О-310Б-21

# Предикаты работы со списками
# Предикат длины списка
```prolog
mylength([], 0).
mylength([_|T], L) :- mylength(T, L1), L is L1 + 1.
```
# Предикат принадлежности элемента списку
```prolog
mymember(X, [X|T]).
mymember(X, [H|T]) :- mymember(X,T).
```
# Предикат конкатенации списков
```prolog
myappend([], X, X).
myappend([H|T], Y, [H|X]) :- myappend(T, Y, X).
```
# Предикат удаления элемента
```prolog
myremove(X, [H|T], [H|Y]) :- myremove(X, T, Y).
myremove(X, [X|T], T).
```
# Предикат перестановки
```prolog
mypermute([],[]).
mypermute(S, [L|Y]) :- myremove(L, S, X), mypermute(X, Y).
```
# Предикат подсписка
```prolog
mysublist(X,Y) :- myappend(A,B,C), myappend(X,A,B).
```

# Получение последнего элемента списка (с использованием встроенных библиотек)
```prolog
getLastElem(L, X) :- append(_, [X], L).
```
# Без встроенных предикатов
```prolog
getLastElemN([X], X).
getLastElemN([_|L], X) :- getLastElemN(L, X).
```
# Предикат суммы
```prolog
mysum([], 0).
mysum([X|T], N) :- mysum(T, N1), N is N1 + X.
```

# Совместное использование предикатов. Вычисление длины, последнего элемента и суммы
```prolog
do(L, LEN, LAST, SUM) :- mylength(L, LEN), getLastElem(L, LAST), mysum(L, SUM).
```
# Вывод
В ходе выполнения лабораторной работы были изучены основы программирования на Prolog. Были реализованы предикаты стандартной библиотеки языка, что позволяет лучше понимать его внутренне устройство.
