;;;; laboratorio6.lisp
;;;; Disciplina de IA - 2017 / 2018
;;;; Ficha de Laborat�rio n�6 - Apoio ao 1� projeto
;;;; Autor: 


;;; Tabuleiros

(defun empty-board (&optional (board-size 14))
  "Retorna um tabuleiro 14x14 (default) com as casas vazias"
	(make-list board-size :initial-element (make-list board-size :initial-element '0))
)

(defun test-board ()
  "Retorna um tabuleiro de teste 14x14 com 4 quadrados 1x1, 1 quadrado 2x2 e 1 cruz"
	'(
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0)
	(0 0 0 0 0 0 0 0 0 0 1 0 0 0)
	(0 0 0 0 0 0 0 0 0 1 1 1 0 0)
	(0 0 0 0 0 0 0 0 0 0 1 0 0 0)
	(0 0 0 0 0 0 0 0 1 1 0 0 0 0)
	(0 0 0 0 0 0 0 0 1 1 0 1 0 0)
	(0 0 0 0 0 0 0 0 0 0 1 0 1 0)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 1)
	)
)




;;; Exercicios
(defun line (index board)
  (nth index board)
)

(defun column (index board)
  (mapcar #'(lambda (line &aux (n-column (nth index line))) n-column) board)
)

(defun board-cell (x y board)
  (nth x (line y board))
)

(defun empty-cellp (x y board)
  (cond ((not (= (board-cell x y board) 0)) nil)
        (t t))
)

(defun verify-empty-cells (board positions)
  (mapcar #' (lambda (board-cell) (empty-cellp (first board-cell) (second board-cell) board)) positions)
)

(defun replace-position (index board-list &optional (value 1))
  (cond ((or(null board-list) (not (numberp index))) nil)
        ((or (< index 0) (> index (length board-list))) nil)
        ((= index 0) (cons value (cdr board-list)))
        (t (cons (car board-list) (replace-position (- index 1) (cdr board-list) value)))
   )
)

(defun replace-board (x y board &optional (value 1))
  (replace-position y board (replace-position y (line x board) value))
)

(defun block-occupied-cells (x y block-type)
  (cond ((eq block-type 'quadrado-1x1) (list (list x y)))
        ((eq block-type 'quadrado-2x2) (list (list x y) (list x (+ y 1))(list (+ 1 x) y) (list (+ x 1) (+ y 1))))
        ((eq block-type 'cruz) (list (list x (+ y 1)) (list (+ x 1) (+ y 1)) (list (+ x 2) (+ y 1))(list (+ x 1) y) (list (+ x 1)(+ y 2))))
        (t nil))
)

(defun square-1x1 (x y board)
  (cond ((eq (empty-cellp x y board) t)  
         (replace-board x y board))
        (t nil))
)

(defun quadrado-2x2(x y tabuleiro)
(cond ((eq (verifica-casas-vazias tabuleiro (peca-casas-ocupadas x y 'quadrado-2x2)) t)
         (labels ((quadrado-aux (x y tabuleiro casas) 
                  (if (null casas) (quadrado-1x1 x y tabuleiro) 
                    (quadrado-aux (first (first casas)) (second (first casas)) (quadrado-1x1 x y tabuleiro) (cdr casas))))) (quadrado-aux x y tabuleiro (peca-casas-ocupadas x y 'quadrado-2x2))))
))

(defun cruz (x y tabuleiro)
(cond ((eq (verifica-casas-vazias tabuleiro (peca-casas-ocupadas x y 'cruz)) t)
         (labels ((quadrado-aux (x y tabuleiro casas) 
                  (if (null casas) (quadrado-1x1 x y tabuleiro) 
                    (quadrado-aux (first (first casas)) (second (first casas)) (quadrado-1x1 x y tabuleiro) (cdr casas))))) (quadrado-aux x y tabuleiro (peca-casas-ocupadas x y 'cruz)))
       (t nil))))

(defun percorrer (board)
  (labels ((percorrer-aux (x y board) 
             (cond ((= x 14) (percorrer-aux 0 (1+ y) board))
                   ((= y 14) nil)
                   ((= (celula x y board) 1) (cons (list (list x y)) (percorrer-aux (1+ x) y board)))
                   (t (percorrer-aux (1+ x) y board)))))
    
    (apply #'append (percorrer-aux 0 0 board))))



