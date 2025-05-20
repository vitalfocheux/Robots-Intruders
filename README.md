<img src="/home/juliengauthier410/master1/s8/pa-Programmation_Avancée/tp/projet/Robots-Intruders/assets/robot_intruders.png" alt="robot intruders" style="zoom:20%;" />

# Robot Intruders

## Le concepts

Un robot doit attraper le plus d'**IA intrus diabolique** en un nombre de coups limités.

Pour atteindre cet objectif, le robot est doté d'un programme de **MASTER PLAYER** écrit en Prolog, qui exploite la puissance de la **programmation logique** pour planifier ses déplacements dans une salle rectangulaire divisée en cases. Le robot évolue dans cet espace en respectant des **règles strictes** : 

il ne peut se déplacer que d'une case à une case voisine, y compris en diagonale, sans jamais sortir des limites de la pièce. 

La situation initiale est définie par <u>la position du robot et celles des intrus</u>, chacun ayant une liste de déplacements successifs à effectuer.

Le défi consiste à déterminer, pour un nombre de déplacements limité, **la meilleure séquence de mouvements permettant au robot de capturer le plus grand nombre d'intrus**. Les intrus, quant à eux, peuvent se déplacer librement, parfois en « sautant » plusieurs cases, et sont retirés du jeu dès qu'ils sont capturés par le robot. Le programme doit donc explorer **efficacement** les différentes possibilités pour **maximiser** le nombre de captures, en s'inspirant de techniques classiques de recherche d'état comme celles utilisées dans le problème <u>des cannibales et des missionnaires</u>.

Ce projet met en avant l'utilisation de *Prolog* pour modéliser des situations complexes, où la logique et la recherche de solutions optimales sont essentielles pour atteindre l'objectif fixé.



## Les fonctions prolog

