% Robot se déplace avant les intrus

find(Length, Width, RobotPos, IntrudersPaths, MaxMoves, BestPath, MaxCaptured) :-
    ( MaxMoves < 0 ->
        fail
    ; \+ two_by_two(RobotPos, IntrudersPaths) ->
        fail
    ; MaxMoves == 0 ->
        BestPath = [RobotPos], MaxCaptured = 0, !
    ; filter_intruders(IntrudersPaths, FilteredPaths),
      find_best(Length, Width, RobotPos, FilteredPaths, 0, MaxMoves, [RobotPos], 0, 0, [], BestPath, MaxCaptured, _, WhenCaptured),
      display(BestPath, MaxCaptured, WhenCaptured)
    ).

find_with_random(Length, Width, RobotPos, IntrudersPaths, MaxMoves, BestPath, MaxCaptured) :-
    ( MaxMoves < 0 ->
        fail
    ; MaxMoves == 0 ->
        BestPath = [RobotPos], MaxCaptured = 0, !
    ; filter_intruders(IntrudersPaths, FilteredPaths),
      find_best(Length, Width, RobotPos, FilteredPaths, 0, MaxMoves, [RobotPos], 0, 0, [], BestPath, MaxCaptured, _, WhenCaptured),
      display(BestPath, MaxCaptured, WhenCaptured)
    ).

all_positions(Length, Width, AllPositions) :-
    findall((X, Y), (
        between(0, Length, X),
        between(0, Width, Y)
    ), AllPositions).

% Vérifie que tous les premiers éléments des IntrudersPaths sont différents entre eux et du RobotPos
two_by_two(RobotPos, IntrudersPaths) :-
    findall(First, (
        member(Path, IntrudersPaths),
        Path = [First | _]
    ), Firsts),
    append([RobotPos], Firsts, AllStarts),
    sort(AllStarts, Sorted),           % Trie et enlève les doublons
    length(AllStarts, L1),
    length(Sorted, L2),
    L1 =:= L2.                         % Si pas de doublons, les longueurs sont égales

display(_, 0, _) :-
    write('No intruders captured'), nl,
    !.

display(BestPath, MaxCaptured, []) :-
    write('Best path: '), write(BestPath), nl,
    write('Max captured: '), write(MaxCaptured), nl,
    !.

display(BestPath, MaxCaptured, [(Pos, Step) | Rest]) :-
    write('Intruder caught! In positition: '), write(Pos), write(' at step: '), write(Step), nl,
    display(BestPath, MaxCaptured, Rest).

find_best(_, _, _, _, Step, MaxMoves, CurrentPath, CurrentCaptured, CurrentScore, CurrentWhenCaptured, CurrentPath, CurrentCaptured, CurrentScore, CurrentWhenCaptured) :-
    Step >= MaxMoves.
find_best(_, _, _, [], _, _, CurrentPath, CurrentCaptured, CurrentScore, CurrentWhenCaptured, CurrentPath, CurrentCaptured, CurrentScore, CurrentWhenCaptured) :- !.
find_best(Length, Width, RobotPos, IntrudersPaths, Step, MaxMoves, CurrentPath, CurrentCaptured, CurrentScore, CurrentWhenCaptured, BestPath, MaxCaptured, BestScore, WhenCaptured) :-
    Step < MaxMoves,
    Diff is MaxMoves - Step,
    (
        Diff >= 5 -> (StepDepth is Step + 5, NextStep is StepDepth) ;
        Diff < 5 -> (StepDepth is Step + Diff, NextStep is StepDepth)
    ),
    findall(
        % (Path, Score, Captured, NewPosRobot, RemainingIntrudersPaths, When),
        Score-(Path, Captured, NewPosRobot, RemainingIntrudersPaths, When),
        simulate_with_score(Length, Width, RobotPos, IntrudersPaths, Step, StepDepth, CurrentPath, CurrentCaptured, CurrentScore, CurrentWhenCaptured, Path, Captured, Score, NewPosRobot, RemainingIntrudersPaths, When),
        Results
    ),
    % Trier les résultats par score
    keysort(Results, SortedResults), % Trier par Score (ascendant)
    last(SortedResults, BestScoreTemp-(BestPathTemp, MaxCapturedTemp, NewPosRobotMax, MinRemainingIntrudersPaths, WhenCapturedMax)), 
    find_best(Length, Width, NewPosRobotMax, MinRemainingIntrudersPaths, NextStep, MaxMoves, BestPathTemp, MaxCapturedTemp, BestScoreTemp, WhenCapturedMax, BestPath, MaxCaptured, BestScore, WhenCaptured).

% Générer une liste de N coordonnées aléatoires dans une grille de dimensions Length x Width
generate_random_coordinates(0, _, _, []). % Cas de base : aucune coordonnée à générer
generate_random_coordinates(N, Length, Width, [(X, Y) | Rest]) :-
    N > 0,
    MaxX is Length - 1, % Limite supérieure pour X
    MaxY is Width - 1, % Limite supérieure pour Y
    random(0, MaxX, X), % Générer une coordonnée X aléatoire
    random(0, MaxY, Y),  % Générer une coordonnée Y aléatoire
    N1 is N - 1,                    % Décrémenter le compteur
    generate_random_coordinates(N1, Length, Width, Rest). % Générer le reste des coordonnées

% Générer plusieurs listes de coordonnées aléatoires
generate_multiple_random_coordinates(0, _, _, _, []). % Cas de base : aucune liste à générer
generate_multiple_random_coordinates(M, N, Length, Width, [Coordinates | Rest]) :-
    M > 0,
    generate_random_coordinates(N, Length, Width, Coordinates), % Générer une liste de N coordonnées
    M1 is M - 1, % Décrémenter le compteur
    generate_multiple_random_coordinates(M1, N, Length, Width, Rest). % Générer le reste des listes

gen(M, N, Length, Width, Lists) :-
    generate_multiple_random_coordinates(M, N, Length, Width, Lists). % Générer M listes de N coordonnées

all_false([]). % Cas de base : une liste vide est considérée comme contenant uniquement des `false`
all_false([false | Rest]) :- % Si le premier élément est `false`
    all_false(Rest). % Vérifier le reste de la liste

filter_intruders([], []). % Cas de base : liste vide
filter_intruders([IntruderPath | Rest], FilteredPaths) :-
    ( all_false(IntruderPath) -> % Si le chemin contient uniquement des `false`
        filter_intruders(Rest, FilteredPaths) % Ne pas inclure cet intrus
    ;
        FilteredPaths = [IntruderPath | RemainingPaths], % Sinon, inclure cet intrus
        filter_intruders(Rest, RemainingPaths)
    ).

simulate_with_score(_, _, RobotPos, IntrudersPaths, MaxMoves, MaxMoves, CurrentPath, CurrentCaptured, CurrentScore, CurrentWhenCaptured, CurrentPath, CurrentCaptured, CurrentScore, RobotPos, IntrudersPaths, CurrentWhenCaptured).
simulate_with_score(_, _, RobotPos, [], _, _, CurrentPath, CurrentCaptured, CurrentScore, CurrentWhenCaptured, CurrentPath, CurrentCaptured, CurrentScore, RobotPos, [], CurrentWhenCaptured).
simulate_with_score(Length, Width, RobotPos, IntrudersPaths, Step, MaxMoves, CurrentPath, CurrentCaptured, CurrentScore, CurrentWhenCaptured, BestPath, MaxCaptured, MaxScore, RP, RIP, WhenCaptured) :-
    Step < MaxMoves,
    valid_moves(Length, Width, RobotPos, NewPositions),
    member(NewPos, NewPositions),
    process_intruders(NewPos, Step, IntrudersPaths, NumCaptured, RemainingIntrudersPaths),
    NewCaptured is CurrentCaptured + NumCaptured,
    append(CurrentPath, [NewPos], NewCurrentPath),
    NextStep is Step + 1,
    (
        NumCaptured > 0 ->
            append(CurrentWhenCaptured, [(NewPos, NextStep)], NewWhenCaptured)
        ;
            NewWhenCaptured = CurrentWhenCaptured
    ),
    calculate_score(NewCaptured, CurrentCaptured, NumCaptured, NewScore, CurrentScore),
    simulate_with_score(Length, Width, NewPos, RemainingIntrudersPaths, NextStep, MaxMoves, NewCurrentPath, NewCaptured, NewScore, NewWhenCaptured, BestPath, MaxCaptured, MaxScore, RP, RIP, WhenCaptured).

calculate_score(NewCaptured, CurrentCaptured, NumCaptured, NewScore, CurrentScore) :-
    ( NewCaptured > CurrentCaptured ->
        NewScore is CurrentScore + NumCaptured * 10
    ;
        NewScore is CurrentScore
    ).

valid_moves(Length, Width, (X,Y), NewPositions) :-
    findall(
        (NewX, NewY),
        (
            between(-1, 1, DX),
            between(-1, 1, DY),
            (DX, DY) \== (0, 0),
            NewX is X + DX,
            NewY is Y + DY,
            NewX >= 0, NewX < Length,
            NewY >= 0, NewY < Width
        ),
        NewPositions
    ).

process_intruders(_, _, [], 0, []). % Cas de base : liste vide
process_intruders(NewPos, Step, [IntruderPath | Rest], NumCaptured, RemainingIntrudersPaths) :-
    resolve_conflicts(NewPos, Step, [IntruderPath | Rest], ResolvedPaths), % Résoudre les conflits
    process_intruders_resolved(NewPos, Step, ResolvedPaths, NumCaptured, RemainingIntrudersPaths).

process_intruders_resolved(_, _, [], 0, []). % Cas de base après résolution
process_intruders_resolved(NewPos, Step, [IntruderPath | Rest], NumCaptured, RemainingIntrudersPaths) :-
    captured(NewPos, Step, IntruderPath), % Si l'intrus est capturé
    process_intruders_resolved(NewPos, Step, Rest, RestCaptured, RemainingIntrudersPaths), % Continuer avec le reste
    NumCaptured is RestCaptured + 1. % Incrémenter le compteur
process_intruders_resolved(NewPos, Step, [IntruderPath | Rest], NumCaptured, [IntruderPath | RemainingRest]) :-
    \+ captured(NewPos, Step, IntruderPath), % Si l'intrus n'est pas capturé
    process_intruders_resolved(NewPos, Step, Rest, RestCaptured, RemainingRest), % Continuer avec le reste
    NumCaptured is RestCaptured. % Copier le compteur sans incrémenter

resolve_conflicts(_, _, [], []). % Cas de base : liste vide
resolve_conflicts(NewPos, Step, [IntruderPath | Rest], [ResolvedPath | ResolvedRest]) :-
    length(IntruderPath, PathLength),
    PathLength > 0,
    Index is Step mod PathLength, % Calculer la position actuelle de l'intrus
    nth0(Index, IntruderPath, Pos),
    count_occurrences(Pos, [IntruderPath | Rest], Count), % Compter les intrus sur cette position
    ( Count > 1 ->
        % Si conflit, déplacer l'intrus vers sa prochaine position ou le laisser à sa position actuelle
        NextIndex is (Index + 1) mod PathLength,
        nth0(NextIndex, IntruderPath, NextPos),
        ResolvedPath = [NextPos | IntruderPath] % Déplacer l'intrus
    ;
        ResolvedPath = IntruderPath % Pas de conflit, garder la position actuelle
    ),
    resolve_conflicts(NewPos, Step, Rest, ResolvedRest).

count_occurrences(_, [], 0). % Cas de base : liste vide
count_occurrences(Pos, [IntruderPath | Rest], Count) :-
    ( member(Pos, IntruderPath) ->
        count_occurrences(Pos, Rest, RestCount),
        Count is RestCount + 1
    ;
        count_occurrences(Pos, Rest, Count)
    ).

captured(RobotPos, Step, IntruderPath) :-
    length(IntruderPath, PathLength),
    PathLength > 0,
    Index is Step mod PathLength,    % Gestion des chemins circulaires
    nth0(Index, IntruderPath, Pos),
    Pos \= false,                   % Vérifier que l'intrus est présent
    Pos == RobotPos.                % Comparaison des coordonnées