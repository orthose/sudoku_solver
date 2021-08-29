<!doctype html>
<html lang="fr">
<head>
  <meta charset="utf-8">
  <title>Solveur de Sudoku</title>
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <link rel="stylesheet" type="text/css" href="https://fonts.googleapis.com/css?family=Ubuntu">
  <style>
  body {
    font-family: "Ubuntu";
    text-align: center;
    margin: 0px;
    padding: 0px;
  }
  table#sudoku {
    display: table;
    table-layout: fixed;
    margin-left: auto;
    margin-right: auto;
    padding: 0px;
    width: 95vw;
    height: 95vw;
  }
  td.sudoku {
    display: table-cell;
    border: 1px solid black;
    height: 33%;
    width: 33%;
  }
  table.square {
    display: table;
    table-layout: fixed;
    width: 100%;
    height: 100%;
  }
  td.square {
    display: table-cell;
    height: 33%;
    width: 100%;
  }
  input {
    border: 1px solid black;
    text-align: center;
    width: 100%;
    height: 100%;
    margin: 0px;
    padding: 0px;
  }
  </style>
</head>
<body>
  <h1>Solveur de Sudoku</h1>
  <?php
  if (!isset($_REQUEST["cell"])) {
    echo "<form action='index.php' method='get'>";
    echo "<table id='sudoku'>";
    for ($i = 0; $i < 3; $i++) {
      echo "<tr class='sudoku'>";
      for ($j = 0; $j < 3; $j++) {
        echo "<td class='sudoku'><table class='square'>";
        for ($ii = 0; $ii < 3; $ii++) {
          echo "<tr class='square'>";
          for ($jj = 0; $jj < 3; $jj++) {
            echo "<td class='square'><input type='number' name='cell-".$ii."-".$jj."' min='1' max='9'></td>";
          }
          echo "</tr>";
        }
        echo "</table></td>";
      }
      echo "</tr>";
    }
    echo "</table>";
    echo "<input type='submit' value='Solution'></form>";
  }
  else {
    echo $_REQUEST["cell"];
  }
  ?>
</body>
</html>