(**************************************************)
(* Programme principal gérant l'interface         *)
(* utilisateur en ligne de commande               *)
(**************************************************)

open Color

(* Comment utiliser le programme ? *)
let usage_msg = 
    "Solveur de sudoku classique 9*9\n"
    ^ "cmd [-if <infile>] [-of <outfile>] [-p] [-v]"

(* Arguments pouvant être modifiés par l'utilisateur *)
let infile = ref ""
let outfile = ref ""
let print_sudoku = ref false
let verbose = ref false

(* Options de la ligne de commande *)
let speclist = [
    ("-if", Arg.Set_string infile, "Fichier de la grille de sudoku à résoudre");
    ("-of", Arg.Set_string outfile, "Fichier de sortie pour enregistrer la solution");
    ("-p", Arg.Set print_sudoku, "Afficher le sudoku résolu sur la sortie standard");
    ("-v", Arg.Set verbose, "Afficher les messages de succès et d'erreur")
]

let main () =
    (* Lecture de la ligne de commande *)
    (* Pas d'arguments anonymes *)
    Arg.parse speclist (fun _ -> ()) usage_msg;
    
    (* Gestion des arguments et erreurs *)
    if (!infile = "" && !outfile = "") then print_sudoku := true;
        
    (* Appel des fonctions *)
    let grid =
        (* Entrée standard *)
        if !infile = "" then
            Sudoku.parse_str (read_line ())
        else 
            Sudoku.parse_file !infile 
    in
    let algo_res = Solver.solve grid in
    let check_res = Solver.check_solution grid in
    
    (* Affichage des résultats *)
    if algo_res then (
        if !verbose then print "Succès de l'algorithme de résolution.\n" Green;
    )
    else (
        if !verbose then print "Echec de l'algorithme de résolution.\n" Red;
        exit 1
    );
    if check_res then (
        if !verbose then print "Solution de la grille correcte.\n" Green;
    )
    else (
        if !verbose then print "Solution de la grille incorrecte.\n" Red;
        exit 2
    );
    if !print_sudoku then Sudoku.print grid;
        
    (* Sauvegarde de la solution *)
    if not !print_sudoku || !outfile <> "" then (
        let file = 
            if !outfile = "" then
                (* On cherche le séparateur de l'extension du
                nom de fichier et on crée le nom du fichier de sortie *)
                let sep = String.index_opt !infile '.' in
                match sep with
                | None -> !infile ^ "_sol"
                | Some i ->
                    let base = String.sub !infile 0 i in
                    let ext = String.sub !infile 
                        (i + 1) (String.length !infile - (String.length base + 1)) in
                    base ^ "_sol." ^ ext
            else !outfile
        in
        if !verbose then print ("Sauvegarde de la solution de la grille dans " ^ file ^ "\n") Yellow; 
        Sudoku.save file grid
        )
    
let () = main ()
