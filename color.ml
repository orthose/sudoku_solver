(**************************************************)
(* Le module Color permet d'afficher du texte en  *)
(* couleur sur la sortie standard                 *)
(**************************************************)

type color = Red | Green | Yellow | Blue | Purple | None

let print s c =
  let print n = Printf.printf "\027[%dm%s\027[0m" n s in
  match c with
  | Red -> print 31
  | Green -> print 32
  | Yellow -> print 33
  | Blue -> print 34
  | Purple -> print 35
  | None -> print_string s

