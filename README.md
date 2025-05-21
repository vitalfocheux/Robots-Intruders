<img src="./assets/robot_intruders.png" alt="robot intruders" style="zoom:20%;" />

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
swipl robot.pl
```

3. Exemple d'appel dans l'interpréteur :
```
?- gen(3,3,10,10,Lists), main_find(10,10,(0,0),Lists,10,BestPath,MaxCaptured).
```

## Les fonctions Prolog

| fonctions                              | description                                                  |
| -------------------------------------- | ------------------------------------------------------------ |
| main_find/6                            | Lance la recherche du meilleur chemin pour le robot, en initialisant la procédure de résolution. |
| find_2/6                               | Gère les cas de base et appelle la recherche principale du meilleur chemin. |
| display/3                              | Affiche le résultat final : le chemin du robot, le nombre d’intrus capturés, et à quel pas chaque capture a eu lieu. |
| find_best/13                           | Explore récursivement les possibilités de déplacement du robot pour maximiser les captures, en sélectionnant à chaque étape le meilleur mouvement. |
| sort_by_score/2                        | Trie une liste de résultats selon le score décroissant.      |
| insert_by_score/3                      | Insère un élément dans une liste triée selon le score, pour maintenir l’ordre décroissant. |
| generate_random_coordinates/4          | Génère une liste de coordonnées aléatoires dans la grille, pour placer les intrus ou le robot. |
| generate_multiple_random_coordinates/5 | Génère plusieurs listes de coordonnées aléatoires, pour simuler plusieurs intrus. |
| gen/5                                  | Raccourci pour générer plusieurs listes de coordonnées aléatoires. |
| all_false/1                            | Vérifie si une liste ne contient que des éléments `false`.   |
| filter_intruders/2                     | Filtre les intrus qui n’ont plus de positions valides.       |
| simulate_with_score/16                 | Simule les déplacements du robot et des intrus sur plusieurs pas, en calculant le score et le nombre de captures. |
| calculate_score/5                      | Calcule le score en fonction du nombre d’intrus capturés.    |
| valid_moves/4                          | Génère toutes les positions voisines valides pour le robot à partir de sa position actuelle. |
| process_intruders/5                    | Met à jour la liste des intrus après un déplacement du robot, en tenant compte des captures. |
| process_intruders_resolved/5           | Gère la liste des intrus après résolution des conflits de position. |
| resolve_conflicts/4                    | Résout les conflits lorsque plusieurs intrus se retrouvent sur la même case. |
| count_occurences/3                     | Compte le nombre d’occurrences d’une position dans les chemins des intrus. |
| captured/3                             | Vérifie si un intrus est capturé par le robot à un pas donné. |


## Ressources utiles

- [Documentation swi-prolog](https://www.swi-prolog.org/)
- [Introduction à Prolog (fr)](https://fr.wikipedia.org/wiki/Prolog)