# Introduction
Algorithme de backtracking pour la résolution de sudoku implémenté en OCaml.
Inspiré de l'idée exposée sur ce [site](http://igm.univ-mlv.fr/~dr/XPOSE2013/sudoku/).
Le coeur de l'algorithme est en soit très court et simple à comprendre.
En revanche, la partie la plus difficile correspondant au pré-processing n'était pas expliquée.
De plus, l'implémentation que j'ai réalisée se veut la plus fonctionnelle possible.
Cependant, la grille de sudoku est stockée sous forme d'une matrice impérative.

# Dépendances
* Seul OCaml et sa bibliothèque standard sont nécessaires.
Je n'ai testé que sous Ubuntu 20.04 le programme.
`sudo apt install ocaml`

# Compilation
* Il suffit d'exécuter `make`
* Pour nettoyer utilisez `make clean`

# Exécution
* La compilation génère le fichier main qu'on peut exécuter avec `./main -help`

```
Solveur de sudoku classique 9*9
cmd [-if <infile>] [-of <outfile>] [-p] [-v]
  -if Fichier de la grille de sudoku à résoudre
  -of Fichier de sortie pour enregistrer la solution
  -p Afficher le sudoku résolu sur la sortie standard
  -v Afficher les messages de succès et d'erreur
  -help  Display this list of options
  --help  Display this list of options
```

* Il n'est pas nécessaire renseigner au moins -if le fichier d'entrée.
En effet, le programme prendra la première ligne donnée en entrée standard comme
grille de sudoku. Les lignes doivent être séparées par des #.

```
echo "9--1----5#--5-9-2-1#8---4----#----8----#---7-----#----26--9#2--3----6#---2--9--#--19-457-" | ./main
```

# Interface web
* Je mets à disposition une interface graphique web (fichier index.php).
Pour l'utiliser il suffit de cloner le dépôt dans un serveur web pouvant exécuter
des scripts PHP, puis de compiler le programme OCaml. Veillez également à donner
la permission d'exécution correcte au fichier main.

```
chmod o+x main
```

* Le programme est utilisable en ligne depuis ce [site](https://pyroxene.ddns.net/sudoku_solver).

# Documentation
* [Site de Céline Périllous](http://igm.univ-mlv.fr/~dr/XPOSE2013/sudoku/index.html)
* [Module Set](https://ocaml.org/api/Set.Make.html)
* [Module List](https://ocaml.org/api/List.html)
* [Module Array](https://ocaml.org/api/Array.html)
* [Module String](https://ocaml.org/api/String.html)
* [Module Arg](https://ocaml.org/api/Arg.html)
* [Manipulation de fichier](https://ocaml.org/learn/tutorials/file_manipulation.html)
