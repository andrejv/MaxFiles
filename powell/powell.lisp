;;; -*-  Mode: Lisp -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Copyright (C) 2007 Andrej Vodopivec <andrejv@users.sourceforge.net>
;;
;;  This program is free software; you can redistribute it and/or modify
;;  it under the terms of the GNU General Public License as published by
;;  the Free Software Foundation; either version 2 of the License, or
;;  (at your option) any later version.
;;
;;  This program is distributed in the hope that it will be useful,
;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;  GNU General Public License for more details.
;;
;;
;;  You should have received a copy of the GNU General Public License
;;  along with this program; if not, write to the Free Software
;;  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar $search_algorithm '$brent)
(defvar $function_calls 0)

(defmacro my-funcall (f x)
  `(progn
    (incf $function_calls)
    (funcall ,f ,x)))

(defmacro my-apply (f x)
  `(progn
    (incf $function_calls)
    (apply ,f ,x)))

(defun brent-search (fun a b c epsilon max-iter)
  (let (d etemp fu fv fw fz
	  p q r (ratio 0.3819660112)
	  tol1 tol2 (e 0.0d0)
	  u (v c) (w c) (z c) midpoint)
    (setf fz (my-funcall fun z))
    (setf fv fz
	  fw fz)
    (loop for iter from 1 to max-iter do
	  (setf midpoint (/ (+ a b) 2))
	  (setf tol1 (+ (* (abs z) epsilon) epsilon))
	  (setf tol2 (* 2 tol1))
	  (if (< (- b a) (* 2 tol2))
	      (return-from brent-search z))
	  (if (> (abs e) tol1)
	      (progn
		(setf r (* (- z w) (- fz fv)))
		(setf q (* (- z v) (- fz fw)))
		(setf p (- (* q (- z v))
			   (* r (- z w))))
		(setf q (* 2 (- q r)))
		(if (> q 0)
		    (setf p (- p))
		    (setf q (- q)))
		(setf etemp e)
		(setf e d)
		(if (or (>= (abs p)
			    (abs (* 0.5 q etemp)))
			(<= p (* q (- a z)))
			(>= p (* q (- b z))))
		    (progn
		      (setf e (if (>= z midpoint)
				  (- a z)
				  (- b z)))
		      (setf d (* ratio e)))
		    (progn
		      (setf d (/ p q))
		      (setf u (+ z d))
		      (if (or (< (- u a) tol2)
			      (< (- b u) tol2))
			  (setf d (if (> (- midpoint z) 0)
				      tol1
				      (- tol1)))))))
	      (progn
		(setf e (if (>= z midpoint)
			    (- a z)
			    (- b z)))
		(setf d (* ratio e))))
	  (setf u (if (>= (abs d) tol1)
		      (+ z d)
		      (+ z (if (> d 0) 
			       tol1
			       (- tol1)))))
	  (setf fu (my-funcall fun u))
	  (if (<= fu fz)
	      (progn
		(if (>= u z)
		    (setf a z)
		    (setf b z))
		(setf v w)
		(setf w z)
		(setf z u)
		(setf fv fw)
		(setf fw fz)
		(setf fz fu))
	      (progn
		(if (< u z)
		    (setf a u)
		    (setf b u))
		(if (or (<= fu fw)
			(= w z))
		    (progn
		      (setf v w)
		      (setf w u)
		      (setf fv fw)
		      (setf fw fu))
		    (if (or (<= fu fv)
			    (= v z)
			    (= v w))
			(setf v u)
			(setf fv fu))))))
    
    (merror "`brent-search' failed to converge")))

(defun golden-ratio-search (fun a b epsilon max-iter)
  (let ((r1 0.61803398874989)
	(r2 0.38196601125011)
	Ya Yb c Yc d Yd (h (- b a)))

    (setf Ya (my-funcall fun a)
	  Yb (my-funcall fun b))
    (setf c (+ a (* r2 h))
	  d (+ a (* r1 h)))
    (setf Yc (my-funcall fun c)
	  Yd (my-funcall fun d))

    (loop while (and (> max-iter 0)
		     (or (> h (* epsilon (/ (+ a b) 2)))
			 (> (abs (- Yb Ya)) (* epsilon (/ (+ Ya Yb) 2)))))
      do
      (if (< Yc Yd)
	  (progn
	    (setf b  d
		  Yb Yd
		  d  c
		  Yd Yc
		  h (- b a)
		  c (+ a (* r2 h)))
	    (setf Yc (my-funcall fun c)))
	  (progn
	    (setf a  c
		  Ya Yc
		  c  d
		  Yc Yd
		  h (- b a)
		  d (+ a (* r1 h)))
	    (setf Yd (my-funcall fun d))))
      (decf max-iter))
    (if (= 0 max-iter)
	($error "`golden-ratio-search' failed to converge.")
	(if (< Ya Yb) a b))))

(defun line-minimum (fun a epsilon max-iter init-step)
  (let (Ya b Yb c Yc (step init-step) ;; how big should the first step be?
	   (r 1.6180339887499076)
	   (maxs max-iter))
    (setf b (+ a step)
	  c (+ a step step))
    (setf Ya (my-funcall fun a)
	  Yb (my-funcall fun b)
	  Yc (my-funcall fun c))
    (loop while (and (not (and (> Ya Yb)
			       (> Yc Yb)))
		     (> maxs 0))
      do
      (if (< Yc Ya)
	  (let ((n (- (* (1+ r) c) (* b r))))
	    (setf a  b
		  Ya Yb
		  b  c
		  Yb Yc
		  c  n
		  Yc (my-funcall fun n)))
	  (let ((n (- (* (1+ r) a) (* b r))))
	    (setf c  b
		  Yc Yb
		  b  a
		  Yb Ya
		  a  n
		  Ya (my-funcall fun n))))
      (decf maxs))
    (if (= 0 maxs)
	($error "`line-minimum' failed to converge")
	(if (eql $search_algorithm '$brent)
	    (brent-search fun a b c epsilon max-iter)
	    (golden-ratio-search fun a c epsilon max-iter)))))


(defun vector-norm (x &aux norm)
  (setf norm 0)
  (loop for i in x do
	(incf norm (* i i)))
  (sqrt norm))

(defmacro create-function (fun arg expr)
  `(coerce `(lambda (s)
	     (apply
	      ,,fun (cdr
		     (coerce
		      (maxima-substitute s ',,arg ',,expr) 'list))))
    'function))

(defun powell-search (fun x0 epsilon max-iter init-step)
  (let* ((n (length x0))
	 (in ($ident n))
	 (i 0)
	 (maxst max-iter)
	 (norm (1+ epsilon))
	 (df (1+ epsilon))
	 (p (make-array (list (1+ n))))
	 (x (make-array (list 2)))
	 (fx (make-array (list 2)))
	 (u (make-array (list n)))
	 (f (make-array (list (1+ n))))
	 (epsilonf 0)
	 (rmax))

    (setf (aref p 0) 
	  (cons '(mlist) (copy-tree x0)))

    (setf (aref x 1)
	  (cons '(mlist) (copy-tree x0))
	  (aref fx 1)
	  (my-apply fun (cdr (aref x 1))))

    (loop for i from 1 to n do
	  (setf (aref u (1- i)) ($first ($row in i))))

    (loop while (and (< i maxst)
		     (or (> df epsilon)
			 (> norm epsilon)))
      do

      (setf (aref x 0) (aref x 1)
	    (aref fx 0) (aref fx 1))

      (setf (aref p 0) (aref x 1))

      (let (tmp sol tmp-fun (tmp-arg (gensym)))
	(setf (aref f 0)
	      (my-apply fun (cdr (aref p 0))))
	
	(setf rmax  0
	      epsilonf -1)
	
	(loop for k from 1 to n do
	      (setf tmp (m+ (aref p (1- k))
			    (m* tmp-arg (aref u (1- k)))))
	      (setf tmp-fun (create-function fun tmp-arg tmp))
	      (setf sol (line-minimum tmp-fun 0 epsilon max-iter init-step))
	      (setf (aref p k)
		    (m+ (aref p (1- k))
			(m* sol (aref u (1- k)))))
	      (setf (aref f k)
		    (my-apply fun (cdr (aref p k))))
	      (if (> (abs (- (aref f (1- k))
			     (aref f k)))
		     epsilonf)
		  (setf rmax k
			epsilonf (abs (- (aref f (1- k))
					 (aref f k))))))
	
	(incf i)
	
	(let ((fe (my-apply fun (cdr (m- (m* 2 (aref  p n))
					 (aref p 0))))))
	  (cond
	    ((> fe (aref f 0))
	     (setf (aref x 1) (aref p n)
		   (aref fx 1) (aref f n)))
	    ((> (* 2 (+ (aref f 0) (* -2 (aref f n)) fe)
		   (expt (- (aref f 0) (aref f n) epsilonf) 2))
		(* epsilonf (expt (- (aref f 0) fe) 2)))
	     (setf (aref x 1) (aref p n)
		   (aref fx 1) (aref f 1)))
	    (t
	     ;; Normalize new direction vector
	     (let ((dir (m- (aref p n) (aref p 0))))
	       (setf (aref u (1- rmax)) (m// dir
					     (vector-norm (cdr dir)))))
	     (setf tmp (m+ (aref p 0)
			   (m* tmp-arg (aref u (1- rmax)))))
	     
	     (setf tmp-fun (create-function fun tmp-arg tmp))
	     (setf sol (line-minimum tmp-fun 0 epsilon max-iter init-step))
	     
	     (setf (aref x 1) (m+ (aref p 0)
				  (m* sol (aref u (1- rmax)))))
	     (setf (aref fx 1)
		   (my-apply fun (cdr (aref x 1))))
	     
	     (setf (aref p 0) (aref x 1))))
	  (setf norm (vector-norm (cdr (m- (aref x 1) (aref x 0)))))
	  (setf df (abs (- (aref fx 1) (aref fx 0)))))))
    
    (if (= i maxst)
	($error "`powell-search' failed to converge."))
    (aref x 1)))

(defun $find_minimum (expr vars init &rest optional)

  ;; maybe we want find_minimum_brent
  (when (and (atom vars)
	     (car optional)
	     ($numberp ($float (car optional))))
    (return-from $find_minimum
      (apply #'$find_minimum_brent
	     (append (list expr vars init)
		     optional))))
  
  (let ((epsilon 1e-6)
	(max-iter 100)
	(init-step 0.3)
	($search_algorithm $search_algorithm)
	($numer t) ($%enumer t))

    (setq $function_calls 0)
    (loop for opt in optional do
	  (if (and (not ($atom opt))
		   (equal (caar opt) 'mequal))
	      (let ((option (cadr opt))
		    (value (caddr opt)))
		(case option
		  ($line_step (setq init-step ($float value)))
		  ($epsilon (setq epsilon ($float value)))
		  ($algorithm (setq $search_algorithm value))
		  ($max_iter (setq max-iter value)) ))))

    (unless (member $search_algorithm '($brent $golden_ratio))
      ($error "Unknown algorithm for 1D minimization:" $search_algorithm))

    (let ((fun (coerce-float-fun
		expr
		(if ($listp vars) vars `((mlist) ,vars)))))
      (if ($listp vars)
	  (let (sol)
	    (setq sol (powell-search fun (cdr init) epsilon max-iter
				     init-step))
	    (setq sol (mapcar #'(lambda (l r) `((mequal simp) ,l ,r))
			      (cdr vars) (cdr sol)))
	    `((mlist simp) ,@sol))
	  (progn
	    `((mlist simp)
	      ((mequal simp)
	       ,vars ,(line-minimum fun init epsilon max-iter init-step))))))
    ))

(defun $find_minimum_brent (expr var a b &rest optional)
  (let ((epsilon 1e-6)
	(max-iter 100)
	(a ($float a))
	(b ($float b))
	($numer t) ($%enumer t))

    (setq $function_calls 0)
    (loop for opt in optional do
	  (if (and (not ($atom opt))
		   (equal (caar opt) 'mequal))
	      (let ((option (cadr opt))
		    (value (caddr opt)))
		(case option
		  ($epsilon (setq epsilon ($float value)))
		  ($max_iter (setq max-iter value)) ))))

    (let ((fun (coerce-float-fun expr `((mlist) ,var))))
      `((mlist simp)
	((mequal simp)
	 ,var ,(brent-search fun (min a b) (max a b) (/ (+ a b) 2.0)
			     epsilon max-iter)))) ))

(defun $brent (&rest args)
  (apply #'$find_minimum_brent args))

(defun $powell (&rest args)
  (apply #'$find_minimum args))
