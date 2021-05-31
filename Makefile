main: color.cmo sudoku.cmo solver.cmo main.cmo
	ocamlc -o main color.cmo sudoku.cmo solver.cmo main.cmo
    
main.cmo: main.ml
	ocamlc -c main.ml
    
color.cmo: color.ml
	ocamlc -c color.ml
    
sudoku.cmo: sudoku.ml
	ocamlc -c sudoku.ml
       
solver.cmo: solver.ml
	ocamlc -c solver.ml
    
clean:
	rm -f *.cmo *.cmi main
