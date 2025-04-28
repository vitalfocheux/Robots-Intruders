%TODO: Sauvegarder les chemins des intrus et robot puis afficher la carte pour visualiser

find(Length, Width, RobotPos, IntrudersPaths, MaxMoves, BestPath, MaxCaptured) :-
    MaxMoves < 0 -> fail ;
    MaxMoves == 0 -> (BestPath = [], MaxCaptured = 0) ;
    % Collecter tous les résultats possibles
    findall(
        (Path, Captured),
        simulate(Length, Width, RobotPos, IntrudersPaths, 0, MaxMoves, [], 0, Path, Captured),
        Results
    ),
    % Trouver le meilleur résultat (avec le MaxCaptured le plus élevé)
    sort(2, @>=, Results, SortedResults), % Trier par MaxCaptured (descendant)
    SortedResults = [(BestPath, MaxCaptured) | _]. % Prendre le premier résultat

simulate(_, _, _, _, MaxMoves, MaxMoves, CurrentPath, CurrentCaptured, CurrentPath, CurrentCaptured).

simulate(Length, Width, RobotPos, IntrudersPaths, Step, MaxMoves, CurrentPath, CurrentCaptured, BestPath, MaxCaptured) :-
    Step < MaxMoves,
    valid_moves(Length, Width, RobotPos, NewPositions),
    member(NewPos, NewPositions),
    process_intruders(NewPos, Step, IntrudersPaths, NumCaptured, RemainingIntrudersPaths),
    NewCaptured is CurrentCaptured + NumCaptured,
    append(CurrentPath, [NewPos], NewCurrentPath),
    NextStep is Step + 1,
    simulate(Length, Width, NewPos, RemainingIntrudersPaths, NextStep, MaxMoves, NewCurrentPath, NewCaptured, BestPath, MaxCaptured).

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