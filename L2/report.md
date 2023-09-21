# Отчет по ЛР2
## Барсуков Егор М8О-310Б-21
# Применение Prolog для решения логических задач

# Задача:
Воронов, Павлов, Левицкий и Сахаров четыре талантливых молодых человека. Один из них танцор, другой художник, третий певец, четвертый писатель. Воронов и Левицкий сидели в зале консерватории в тот вечер, когда певец дебютировал в сольном концерте. Павлов и писатель вместе позировали художнику. Писатель написал биографическую повесть о Сахарове и собирается написать о Воронове. Воронов никогда не слышал о Левицком. Кто чем занимается?

# Решение
Решение подробно описано в комментариях к коду. Вводим отношения knows, которое показывает, как один объект может "знать" другого.
```prolog
% if first one somewhow knows second
knows(pavlov, artist).
knows(artist, pavlov).
knows(writer, artist).
knows(artist, writer).
knows(writer, saharov).
knows(writer, voronov).
knows(pavlov, writer).
knows(writer, pavlov).
knows(voronov, levickiy).
```
Вспомогательные функции для работы по списками:
```prolog
% if something in list
in([L|_], L).
in([_|T], L) :- in(T, L).

% check knowledge
meets([X|Y],[X1|Y1]) :- knows(X, X2); knows(Y, X2); knows(X, Y2); knows(Y, X2).

% merging...
merge([], [], []).
merge([H1|T1], [H2|T2], [[H1,H2]|X]) :- merge(T1, T2, X).
```
Основная функция поиска ответа. Создаются все возможные соотношения имя - профессия. Такой подход гарантирует, что мы рассмотрим все варианты и выберем один правильный. \
Далее устанавливаются общие правила, которые отсекают лишние и точно не подходящие соотношения. \
Финально отбирается подходящая комбинация.
```prolog
% find out
find :-
    permutation(NAMES, [voronov, pavlov, levickiy, sakharov]), % all permutations with names
    permutation(PROFS, [dancer, artist, singer, writer]), % all profs orientations
    merge(NAMES, PROFS, NP), % all connections name - prof

    % voronov and levickiy cant be singer
    not(in(NP, [voronov, singer])),
    not(in(NP, [levickiy, singer])),

    % pavlov cant be artist and writer
    not(in(NP, [pavlov, artist])),
    not(in(NP, [pavlov, writer])),

    % voronov and sakharov cant be writer
    not(in(NP, [voronov, writer])),
    not(in(NP, [sakharov, writer])),
    
    meets([voronov, _], [levickiy, _]),
    meets([_, artist], [pavlov, _]),
    meets([_, artist], [_, writer]),
    meets([pavlov, _], [_, writer]),
    meets([_, writer], [pavlov, _]),
    meets([pavlov, _], [_, artist]),
    meets([_, writer], [_, artist]),
    meets([_, writer], [sakharov, _]),
    meets([_, writer], [voronov, _]),

    write(NP).
```
# Вывод
В ходе данной лабораторной работы язык prolog был применен к настоящей задаче. Он показал себя как прекрасный инструмент, который позволяет эффективно решать подобного рода задачи.
