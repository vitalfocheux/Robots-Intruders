<img src="./assets/robot_intruders.png" alt="robot intruders" style="display: block; margin-left: auto; margin-right: auto; width: 200px; height: auto;">


# Robot Intruders

## Le concepts

Un robot doit attraper le plus d'**IA intrus diabolique** en un nombre de coups limités.

Pour atteindre cet objectif, le robot est doté d'un programme de **MASTER PLAYER** écrit en Prolog, qui exploite la puissance de la **programmation logique** pour planifier ses déplacements dans une salle rectangulaire divisée en cases. Le robot évolue dans cet espace en respectant des **règles strictes** : 

il ne peut se déplacer que d'une case à une case voisine, y compris en diagonale, sans jamais sortir des limites de la pièce. 

La situation initiale est définie par <u>la position du robot et celles des intrus</u>, chacun ayant une liste de déplacements successifs à effectuer.

Le défi consiste à déterminer, pour un nombre de déplacements limité, **la meilleure séquence de mouvements permettant au robot de capturer le plus grand nombre d'intrus**. Les intrus, quant à eux, peuvent se déplacer librement, parfois en « sautant » plusieurs cases, et sont retirés du jeu dès qu'ils sont capturés par le robot. Le programme doit donc explorer **efficacement** les différentes possibilités pour **maximiser** le nombre de captures, en s'inspirant de techniques classiques de recherche d'état comme celles utilisées dans le problème <u>des cannibales et des missionnaires</u>.

Ce projet met en avant l'utilisation de *Prolog* pour modéliser des situations complexes, où la logique et la recherche de solutions optimales sont essentielles pour atteindre l'objectif fixé.

## Installation et utilisation

1. Installe swi-prolog :
- Linux :
```
sudo apt-get install swi-prolog
```

2. Compile et lance le programme dans le dossier du projet :
```
swipl -s robot.pl
```

3. Exemple d'appel dans l'interpréteur :
```
?- gen(3,3,10,10,Lists), main_find(10,10,(0,0),Lists,10,BestPath,MaxCaptured).
```


---

## Les fonctions Prolog

| Fonction | Description |
|---|---|
| [find/6](#find) | Gère les cas de base et appelle la recherche principale du meilleur chemin. |
| [find_with_random/6](#find_with_random) | Gère les cas de base sans vérifier la séparation initiale des positions et lance la recherche du meilleur chemin. |
| [two_by_two/2](#two_by_two) | Vérifie que tous les premiers éléments des chemins des intrus sont différents entre eux et du robot. |
| [display/3](#display) | Affiche le chemin du robot, le nombre d’intrus capturés, et à quel pas chaque capture a eu lieu. |
| [find_best/13](#find_best) | Explore récursivement les possibilités de déplacement du robot pour maximiser les captures. |
| [sort_by_score/2](#sort_by_score) | Trie une liste de résultats selon le score décroissant. |
| [insert_by_score/3](#insert_by_score) | Insère un élément dans une liste triée selon le score. |
| [generate_random_coordinates/4](#generate_random_coordinates) | Génère une liste de coordonnées aléatoires dans la grille. |
| [generate_multiple_random_coordinates/5](#generate_multiple_random_coordinates) | Génère plusieurs listes de coordonnées aléatoires pour simuler plusieurs intrus. |
| [gen/5](#gen) | Raccourci pour générer plusieurs listes de coordonnées aléatoires. |
| [all_false/1](#all_false) | Vérifie si une liste ne contient que des éléments `false`. |
| [filter_intruders/2](#filter_intruders) | Filtre les intrus qui n’ont plus de positions valides. |
| [simulate_with_score/16](#simulate_with_score) | Simule les déplacements du robot et des intrus, et calcule score et captures. |
| [calculate_score/5](#calculate_score) | Calcule le score en fonction du nombre d’intrus capturés. |
| [valid_moves/4](#valid_moves) | Génère toutes les positions voisines valides pour le robot. |
| [process_intruders/5](#process_intruders) | Met à jour la liste des intrus après un déplacement du robot. |
| [process_intruders_resolved/5](#process_intruders_resolved) | Gère la liste des intrus après résolution des conflits de position. |
| [resolve_conflicts/4](#resolve_conflicts) | Résout les conflits lorsque plusieurs intrus se retrouvent sur la même case. |
| [count_occurrences/3](#count_occurrences) | Compte le nombre d’occurrences d’une position dans les chemins des intrus. |
| [captured/3](#captured) | Vérifie si un intrus est capturé par le robot à un pas donné. |

---

## Les paramètres

### find
- **Length** : Longueur de la grille (nombre de colonnes)
- **Width** : Largeur de la grille (nombre de lignes)
- **RobotPos** : Position initiale du robot, sous la forme (X, Y)
- **IntrudersPaths** : Liste des chemins de chaque intrus (listes de positions)
- **MaxMoves** : Nombre maximal de déplacements autorisés pour le robot
- **BestPath** : (sortie) Chemin optimal trouvé pour le robot
- **MaxCaptured** : (sortie) Nombre maximal d’intrus capturés

### find_with_random
- **Length** : Longueur de la grille
- **Width** : Largeur de la grille
- **RobotPos** : Position initiale du robot
- **IntrudersPaths** : Chemins des intrus
- **MaxMoves** : Nombre maximal de déplacements
- **BestPath** : (sortie) Chemin optimal trouvé
- **MaxCaptured** : (sortie) Nombre maximal d’intrus capturés

### two_by_two
- **RobotPos** : Position du robot
- **IntrudersPaths** : Liste des chemins des intrus

### display
- **BestPath** : Chemin optimal du robot
- **MaxCaptured** : Nombre total d’intrus capturés
- **WhenCaptured** : Liste des couples (position, étape) des captures

### find_best
- **Length** : Longueur de la grille
- **Width** : Largeur de la grille
- **RobotPos** : Position actuelle du robot
- **IntrudersPaths** : Chemins restants des intrus
- **Step** : Étape courante
- **MaxMoves** : Limite de déplacements
- **CurrentPath** : Chemin parcouru jusque-là
- **CurrentCaptured** : Nombre d’intrus capturés jusque-là
- **CurrentScore** : Score actuel
- **CurrentWhenCaptured** : Historique des captures
- **BestPath** : (sortie) Meilleur chemin
- **MaxCaptured** : (sortie) Nombre maximal de captures
- **BestScore** : (sortie) Score maximal
- **WhenCaptured** : (sortie) Historique final des captures

### sort_by_score
- **Results** : Liste de résultats à trier
- **SortedResults** : (sortie) Liste triée par score décroissant

### insert_by_score
- **Element** : Élément à insérer (avec score)
- **List** : Liste triée
- **NewList** : (sortie) Nouvelle liste avec l’élément inséré

### generate_random_coordinates
- **N** : Nombre de coordonnées à générer
- **Length** : Longueur de la grille
- **Width** : Largeur de la grille
- **Coordinates** : (sortie) Liste de coordonnées générées

### generate_multiple_random_coordinates
- **M** : Nombre de listes à générer
- **N** : Nombre de coordonnées par liste
- **Length** : Longueur de la grille
- **Width** : Largeur de la grille
- **Lists** : (sortie) Listes de coordonnées générées

### gen
- **M** : Nombre de listes à générer
- **N** : Nombre de coordonnées par liste
- **Length** : Longueur de la grille
- **Width** : Largeur de la grille
- **Lists** : (sortie) Listes de coordonnées générées

### all_false
- **List** : Liste à vérifier (contient uniquement des `false` si vrai)

### filter_intruders/2
- **IntrudersPaths** : Chemins des intrus
- **FilteredPaths** : (sortie) Chemins valides restants

### simulate_with_score
- **Length** : Longueur de la grille
- **Width** : Largeur de la grille
- **RobotPos** : Position du robot
- **IntrudersPaths** : Chemins des intrus
- **Step** : Étape courante
- **MaxMoves** : Nombre maximal de déplacements
- **CurrentPath** : Chemin courant
- **CurrentCaptured** : Captures courantes
- **CurrentScore** : Score courant
- **CurrentWhenCaptured** : Historique des captures courantes
- **BestPath** : (sortie) Chemin optimal
- **MaxCaptured** : (sortie) Nombre maximal de captures
- **MaxScore** : (sortie) Score maximal
- **RP** : (sortie) Position finale du robot
- **RIP** : (sortie) Chemins restants des intrus
- **WhenCaptured** : (sortie) Historique des captures

### calculate_score
- **NewCaptured** : Nombre d’intrus capturés après le mouvement
- **CurrentCaptured** : Nombre d’intrus capturés avant le mouvement
- **NumCaptured** : Nombre d’intrus capturés dans ce mouvement
- **NewScore** : (sortie) Score mis à jour
- **CurrentScore** : Score avant le mouvement

### valid_moves/4
- **Length** : Longueur de la grille
- **Width** : Largeur de la grille
- **RobotPos** : Position actuelle du robot
- **NewPositions** : (sortie) Positions voisines valides

### process_intruders
- **NewPos** : Nouvelle position du robot
- **Step** : Étape courante
- **IntrudersPaths** : Chemins des intrus
- **NumCaptured** : (sortie) Nombre d’intrus capturés à cette étape
- **RemainingIntrudersPaths** : (sortie) Chemins restants

### process_intruders_resolved
- **NewPos** : Nouvelle position du robot
- **Step** : Étape courante
- **ResolvedPaths** : Chemins des intrus après résolution des conflits
- **NumCaptured** : (sortie) Nombre d’intrus capturés
- **RemainingIntrudersPaths** : (sortie) Chemins restants

### resolve_conflicts
- **NewPos** : Nouvelle position du robot
- **Step** : Étape courante
- **IntrudersPaths** : Chemins des intrus
- **ResolvedPaths** : (sortie) Chemins après résolution des conflits

### count_occurrences
- **Pos** : Position à compter
- **IntrudersPaths** : Chemins des intrus
- **Count** : (sortie) Nombre d’occurrences

### captured
- **RobotPos** : Position du robot
- **Step** : Étape courante
- **IntruderPath** : Chemin de l’intrus

---

## Ressources utiles

- [Documentation SWI-Prolog](https://www.swi-prolog.org/)
- [Introduction à Prolog (fr)](https://fr.wikipedia.org/wiki/Prolog)
