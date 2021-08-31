<!doctype html>
<html lang="fr">
<head>
  <meta charset="utf-8">
  <title>Solveur de Sudoku</title>
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <link rel="stylesheet" type="text/css" href="https://fonts.googleapis.com/css?family=Ubuntu">
  <style>
  /* Téléphone toute la largeur de l'écran */
  @media (width < 500px) {
    body {
      width: 100%;
      margin: 0px;
    }
    table { 
      width: 99vw;
      height: 99vw;
    }
  }
  /* Ordinateur taille maximale de 500px */
  @media (width >= 500px) {
    body {
      width: 500px;
      display: block;
      margin-left: auto;
      margin-right: auto;
    }
    table {
      width: 500px;
      height: 500px;
    }
  }
  body {
    background: lightskyblue;
    font-family: "Ubuntu";
    text-align: center;
    padding: 0px;
  }
  h1 {
    color: white;
    background: blue;
  }
  table {
    border-collapse: collapse;
    display: table;
    table-layout: fixed;
    margin-left: auto;
    margin-right: auto;
    padding: 0px;
  }
  td {
    display: table-cell;
    border: 1px solid black;
    height: 11%;
    margin: 0px;
    padding: 0px;
  }
  td:nth-child(3), td:nth-child(6) {
    border-right: 3px solid black;
  }
  tr:nth-child(3) td, tr:nth-child(6) td {
    border-bottom: 3px solid black;
  }
  input[type="number"] {
    border: none;
    text-align: center;
    width: 100%;
    height: 100%;
    margin: 0px;
    padding: 0px;
  }
  input[type="submit"], a.button_link {
    display: block;
    font-size: medium;
    font-weight: normal;
    box-sizing: border-box; 
    width: 100%;
    color: blue;
    text-decoration: none;
    border-radius: 3px;
    border: 3px solid blue;
    background: cyan;
    margin: 0px;
    padding: 0px;
  }
  input[type="submit"]:hover, a.button_link:hover {
    background: blue;
    color: white;
  }
  p.error {
    color: white;
    text-align: center;
    border: 3px solid indianred;
    background: lightcoral;
  }
  </style>
</head>
<body>
  <h1>Solveur de Sudoku</h1>
  <a class="button_link" href="index.php">Recommencer</a>
  <?php  
  
  // Initialisation du tableau de sudoku
  $sudoku = array();
  for ($i = 0; $i < 9; $i++) {
    for ($j = 0; $j < 9; $j++) {
      // Sauvegarde des entrées utilisateur pour l'affichage
      if (isset($_REQUEST["cell-$i-$j"])) {
        $sudoku[$i][$j] = $_REQUEST["cell-$i-$j"];
      }
      else {
        $sudoku[$i][$j] = "";
      }
    }
  }
  
  // Calcul de la solution et affichage
  if (isset($_REQUEST["cell"]) && $_REQUEST["cell"]) {
    // Traduction en chaîne de caractères de la grille
    $grid = "";
    for ($i = 0; $i < 9; $i++) {
      for ($j = 0; $j < 9; $j++) {
        $cell = $_REQUEST["cell-$i-$j"];
        if ($cell === "") {
          $grid .= "-";
        }
        else {
          $grid .= $cell;
        }
      }
      $grid .= "#";
    }
    
    // Appel du programme OCaml
    $cmd = 'echo "'.$grid.'" | ./main';
    exec($cmd, $res, $code);
    
    // Gestion des codes d'erreur
    if ($code === 1) { // Grille de départ insoluble
      echo "<p class='error'>La grille de départ est insoluble car des doublons ont été détectés.</p>";
    }
    else if ($code === 2) { // Échec de l'algortihme de résolution
      echo "<p class='error'>L'algorithme de résolution a échoué. La grille n'admet aucune solution.</p>";
    }
    // En principe cette erreur ne devrait jamais arriver
    else if ($code === 3) { // Solution de l'algorithme incorrecte
      echo "<p class='error'>La solution donnée par l'algorithme est incorrecte. Des doublons ont été détectés ou des cases n'ont pas été remplies.</p>";
    }
    // Sauvegarde de la solution pour l'affichage
    else {
      foreach ($res as $i => $line) {
        $line_clean = str_replace(" ", "", $line);
        foreach (str_split($line_clean) as $j => $n) {
          $sudoku[$i][$j] = $n;
        } 
      }
    }
  }
  
  // Affichage et entrée utilisateur de la grille de sudoku
  echo "<form action='index.php' method='post'>";
  $input_hidden = "<input type='hidden' name='cell' value=";
  if (isset($_REQUEST["cell"]) && $_REQUEST["cell"]) {
    $input_hidden .= "'false'>";
  }
  else {
    $input_hidden .= "'true'>";
  }
  echo $input_hidden;
  echo "<table>";
  for ($i = 0; $i < 9; $i++) {
    echo "<tr>";
    for ($j = 0; $j < 9; $j++) {
      echo "<td><input type='number' min='1' max='9' name='cell-".$i."-".$j."' value='".$sudoku[$i][$j]."'></td>";
    }
    echo "</tr>";
  }
  echo "</table>";
  echo "<input type='submit' value='Solution'></form>";
  
  ?><br>
  <footer>
    Code source disponible sur <a href="https://github.com/orthose/sudoku_solver">Github</a>.
  </footer>
</body>
</html>