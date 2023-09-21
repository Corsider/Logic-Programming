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

% if something in list
in([L|_], L).
in([_|T], L) :- in(T, L).

% check knowledge
meets([X|Y],[X1|Y1]) :- knows(X, X2); knows(Y, X2); knows(X, Y2); knows(Y, X2).

% merging...
merge([], [], []).
merge([H1|T1], [H2|T2], [[H1,H2]|X]) :- merge(T1, T2, X).

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
