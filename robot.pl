% map(+Length, +Width, +Robot, +Intruders)
% Length: longueur de la carte
% Width: largeur de la carte
% Robot: position du robot (X, Y)
% Intruders: liste des positions des intrus [(X1, Y1), (X2, Y2), ...]

map(Length, Width, (RobotX, RobotY), Intruders) :-
    draw_top_border(Length),
    draw_rows(Length, Width, (RobotX, RobotY), Intruders, 0),
    draw_bottom_border(Length).

% Dessiner la bordure supérieure
draw_top_border(Length) :-
    write('+'), draw_horizontal_line(Length), write('+'), nl.

% Dessiner la bordure inférieure (identique à la supérieure)
draw_bottom_border(Length) :-
    draw_top_border(Length).

% Dessiner une ligne horizontale
draw_horizontal_line(0).
draw_horizontal_line(N) :-
    N > 0,
    write('-'),
    N1 is N - 1,
    draw_horizontal_line(N1).

% Dessiner les lignes de la carte
draw_rows(_, Width, _, _, Row) :-
    Row >= Width, !. % Arrêter quand toutes les lignes sont dessinées
draw_rows(Length, Width, Robot, Intruders, Row) :-
    ActualRow is Width - 1 - Row, % Inverser l'axe vertical
    write('|'),
    draw_row_content(Length, ActualRow, Robot, Intruders, 0),
    write('|'), nl,
    NextRow is Row + 1,
    draw_rows(Length, Width, Robot, Intruders, NextRow).

% Dessiner le contenu d'une ligne
draw_row_content(Length, _, _, _, Col) :-
    Col >= Length, !. % Arrêter quand toutes les colonnes sont dessinées
draw_row_content(Length, Row, (RobotX, RobotY), Intruders, Col) :-
    (RobotX =:= Col, RobotY =:= Row -> write('R') ; % Placer le robot
     member((Col, Row), Intruders) -> write('I') ; % Placer un intrus
     write(' ')), % Sinon, espace vide
    NextCol is Col + 1,
    draw_row_content(Length, Row, (RobotX, RobotY), Intruders, NextCol).