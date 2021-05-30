module Feasible = Set.Make(Int)
type location = { pos : int * int; feasible : Feasible.t }
open Feasible

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
    (* TODO: Utiliser Array.fold_right avec acc = (i, []) *)
    let rec compute_locations i j acc =
        if i < 9 then
            if j < 9 then
                if grid.(i).(j) = None then
                    let loc = { 
                        pos = (i, j);
                        feasible = feasible_all_direction i j grid
                    } in
                    compute_locations i (j + 1) (loc :: acc)
                else compute_locations i (j + 1) acc
            else compute_locations (i + 1) 0 acc
        else acc
    in
    List.map (fun x -> x.pos) (List.sort (fun a b -> 
        (Feasible.cardinal a.feasible) - (Feasible.cardinal b.feasible)
        ) (compute_locations 0 0 []))

(* Algorithme de backtracking vérifiant la validité du sudoku
inspiré de http://igm.univ-mlv.fr/~dr/XPOSE2013/sudoku/ *)
let rec is_valid grid locations =
    match locations with
    | [] -> true
    | (i, j) :: s ->
        let feasible = feasible_all_direction i j grid in
        exists (fun x -> grid.(i).(j) <- Some x; 
            let res = is_valid grid s in
            if not res then grid.(i).(j) <- None; res) feasible

let solve grid =
    is_valid grid (compute_locations grid)

(* Vérifie que la solution est correcte en vérifiant que toutes les
cases sont remplies et qu'il n'y a pas de doublon *)
let check_solution grid =
    let for_alli f a =
        let n = Array.length a in
        let rec for_alli i =
            if i = n then true
            else f i && for_alli (i + 1)
        in for_alli 0 
    in  
    for_alli (fun i ->
        for_alli (fun j ->
            grid.(i).(j) <> None
            (* Y a-t-il un doublon ? *)
            && cardinal (feasible_row i j grid) = 0
            && cardinal (feasible_row i j grid) = 0
            && cardinal (feasible_row i j grid) = 0
        ) grid.(i)) grid

