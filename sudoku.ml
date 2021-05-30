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
    let rec fill i =
        if i < 9 then        
        try
            let line = input_line cursor in
            if String.length line <> 9 then
                failwith "Parsing error inconsistent format"
            else let () = 
                String.iteri (fun j c -> match c with
                |'1'|'2'|'3'|'4'|'5'|'6'|'7'|'8'|'9' ->
                    res.(i).(j) <- Some (int_of_string (String.make 1 c))       
                |'-' -> () 
                | _ -> failwith "Parsing error inconsistent"
                ) line in fill (i + 1)
        with End_of_file -> close_in cursor
    in let () = fill 0 in res

(* Affichage de sudoku en console *)
let print_sudoku =
    let print x = Printf.printf "%c" (match x with
        | None -> '?'
        | Some y -> (string_of_int y).[0]
        )
    in
    Array.iter (fun a -> 
        Array.iter (fun x -> print x) a; 
        print_endline "")
    
