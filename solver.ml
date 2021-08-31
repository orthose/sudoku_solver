(**************************************************)
(* Le module Solver contient toutes les fonctions *)
(* de résolution de sudoku                        *)
(**************************************************)

module Feasible = Set.Make(Int)
(* Type pour le pré-processing *)
type location = { pos : int * int; feasible : Feasible.t }
open Feasible

(* Tous les nombres possibles mis dans un ensemble *)
let all = List.fold_right Feasible.add
    [1;2;3;4;5;6;7;8;9] Feasible.empty

(* Pattern de recherche des nombres possibles *)
let find_feasible i j grid cond next =
    let rec find_feasible i j feasible =
        if cond i j then
            let (i', j') = next i j in
            match grid.(i).(j) with
            | Some x -> find_feasible i' j' (remove x feasible)
            | None -> find_feasible i' j' feasible
        else feasible
    in find_feasible i j all

(* Pour la ligne *)
let feasible_row i j grid =
    find_feasible i 0 grid 
        (fun i j -> j < 9) 
        (fun i j -> (i, j + 1))

(* Pour la colonne *)
let feasible_column i j grid =
    find_feasible 0 j grid 
        (fun i j -> i < 9) 
        (fun i j -> (i + 1, j))

(* Pour le carré *)
let feasible_square i j grid =
    (* Dans quel carré suis-je ? *)
    let (si, sj) = ((i / 3) * 3, (j / 3) * 3) in
    find_feasible si sj grid 
        (fun i j -> i < si + 3 && j < sj + 3) 
        (fun i j -> if j < sj + 2 then (i, j + 1) else (i + 1, sj))

(* Les 3 contraintes en même temps *)
let feasible_all_direction i j grid =
    inter 
        (feasible_row i j grid)
        (inter 
            (feasible_column i j grid)
            (feasible_square i j grid)
        )

(* Calcul la liste des cases à remplir dans l'ordre croissant
du nombre de possibilités de chaque case *)
let compute_locations grid =
    (* Parcours de la grille du sudoku et calcul du nombre de
    possibilités pour chaque emplacement *)
    let locations = snd (
    Array.fold_left (fun acc1 a ->
        let (i, res1) = acc1 in
        let (_, res2) = 
        Array.fold_left (fun acc2 x ->
            let (j, res2) = acc2 in
            if grid.(i).(j) = None then
                let loc = { 
                    pos = (i, j);
                    feasible = feasible_all_direction i j grid
                } in (j + 1, loc :: res2)
            else (j + 1, res2)
        ) (0, res1) a in
        (i + 1, res2)
    ) (0, []) grid) in
    
    (* Tri par ordre croissant du nombre de possibiltés *)
    List.map (fun x -> x.pos) (List.sort (fun a b -> 
        (Feasible.cardinal a.feasible) - (Feasible.cardinal b.feasible)
        ) locations)

(* Algorithme de backtracking vérifiant la validité du sudoku
inspiré de http://igm.univ-mlv.fr/~dr/XPOSE2013/sudoku/ *)
let rec is_valid grid locations =
    match locations with
    | [] -> true
    | (i, j) :: s ->
        let feasible = feasible_all_direction i j grid in
        exists (fun x -> grid.(i).(j) <- Some x; 
            let res = is_valid grid s in
            if not res then grid.(i).(j) <- None; res
            ) feasible

(* Résolution du sudoku *)
let solve grid =
    is_valid grid (compute_locations grid)  

(* for_all pour parcourir matrice *)
let rec for_all_matrix i j cond next stop =
    if stop i j then true
    else 
        let (i', j') = next i j in
        (cond i j) && (for_all_matrix i' j' cond next stop)

(* Vérifie que la solution est correcte en vérifiant que toutes les
cases sont remplies et qu'il n'y a pas de doublon *)
let check_solution grid =  
    for_all_matrix 0 0 (fun i j ->
        (* La grille est-elle remplie ? *)
        grid.(i).(j) <> None
        (* Y a-t-il un doublon ? *)
        && cardinal (feasible_row i j grid) = 0
        && cardinal (feasible_column i j grid) = 0
        && cardinal (feasible_square i j grid) = 0
        ) 
    (fun i j -> if j = 8 then (i + 1, 0) else (i, j + 1)) 
    (fun i j -> i = 9)
        
(* Vérifie que la grille est résolvable avant de tenter la résolution
sinon l'algortihme ne termine pas forcément *)
let is_solvable grid =
    for_all_matrix 0 0 (fun i j ->
        match grid.(i).(j) with
        (* Un emplacement vide n'est pas pris en compte *)
        | None -> true
        (* Y a-t-il un doublon dans toutes les directions ? *)
        | Some x ->
            (* Dans quel carré suis-je ? *)
            let (si, sj) = ((i / 3) * 3, (j / 3) * 3) in
            let cond ci cj =
                match grid.(ci).(cj) with
                | None -> true
                (* On ignore la case où (i, j) = (ci, cj) *)
                | Some y -> x <> y || (i, j) = (ci, cj)
            in
            (* Horizontalement *)
            for_all_matrix i 0 cond
                (fun ci cj -> (ci, cj + 1))
                (fun ci cj -> cj = 9)
            (* Verticalement *)
            && for_all_matrix 0 j cond
                (fun ci cj -> (ci + 1, cj))
                (fun ci cj -> ci = 9)
            (* Carré *)
            && for_all_matrix si sj cond
                (fun ci cj -> if cj = sj + 2 then (ci + 1, sj) else (ci, cj + 1))
                (fun ci cj -> ci = si + 3 && cj = sj)
        )
    (fun i j -> if j = 8 then (i + 1, 0) else (i, j + 1)) 
    (fun i j -> i = 9)

