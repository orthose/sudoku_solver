(**************************************************)
(* Le module Sudoku contient toutes les fonctions *)
(* de manipulation de sudoku avec des fichiers ou *)
(* via la console et l'entrée/sortie standard     *)
(**************************************************)

(* Exemple de grille *)
let grid1 = [|
    [|Some 9;None;None;Some 1;None;None;None;None;Some 5|];
    [|None;None;Some 5;None;Some 9;None;Some 2;None;Some 1|];
    [|Some 8;None;None;None;Some 4;None;None;None;None|];
    [|None;None;None;None;Some 8;None;None;None;None|];
    [|None;None;None;Some 7;None;None;None;None;None|];
    [|None;None;None;None;Some 2;Some 6;None;None;Some 9|];
    [|Some 2;None;None;Some 3;None;None;None;None;Some 6|];
    [|None;None;None;Some 2;None;None;Some 9;None;None|];
    [|None;None;Some 1;Some 9;None;Some 4;Some 5;Some 7;None|]
|]

(* Vérifie que le sudoku est une matrice 9*9 *)
let is_sudoku grid =
    Array.length grid = 9 && Array.length grid.(0) = 9

(* Parsing de fichier de grille de sudoku et renvoie la matrice *)   
let parse file =
    let cursor = open_in file in
    let res = Array.make_matrix 9 9 None in
    
    (* Partial mapping avec f : string -> string *)
    let map_str f s =
        let n = String.length s in
        let rec map_str i acc =
            if i < n then 
                map_str (i + 1) (acc ^ (f (String.make 1 s.[i])))
            else acc 
        in map_str 0 ""
    in
    
    (* Parcours de toutes les lignes du fichier *)
    let rec fill i =
        if i < 9 then        
        try
            let line =
                (* On ignore les espaces *)
                map_str (fun s -> if s = " " then "" else s)
                (input_line cursor) 
            in
            let width = String.length line in
            if width <> 9 then
                failwith ("width = " ^ (string_of_int width) ^ " != 9") 
            else let () =
                String.iteri (fun j c -> match c with
                |'1'|'2'|'3'|'4'|'5'|'6'|'7'|'8'|'9' ->
                    (* On convertit char en int *)
                    res.(i).(j) <- Some (int_of_string (String.make 1 c))       
                |'-' -> ()
                | c -> failwith ("invalid token " ^ (String.make 1 c))
                ) line in fill (i + 1)
        with End_of_file -> 
            close_in cursor;
            if i < 9 then failwith ("height = " ^ (string_of_int i) ^ " != 9")
    in let () = fill 0 in res

(* Conversion de la grille du sudoku vers string *)
let to_string =
    Array.fold_left (fun acc1 a -> acc1 ^ (
        Array.fold_left (fun acc2 x ->
            let s = match x with
                | None -> "-"
                | Some y -> (string_of_int y)
            in acc2 ^ s ^ " " 
        ) "" a) ^ "\n"
    ) ""
    
(* Affichage de sudoku en console *)
let print grid =
    Printf.printf "%s" (to_string grid)

(* Enregistrement dans un fichier une grille de sudoku *)    
let save file grid =
    let oc = open_out file in
    Printf.fprintf oc "%s" (to_string grid);
    close_out oc
    
