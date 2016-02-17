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


(in-package :maxima)

(defun $nintegrate (arg var lo hi)
  (simplify (list '(%nintegrate) arg var lo hi)))

(defprop %nintegrate nintegrate-simp operators)

(defun check-result (res)
  (if (= (nth 4 res) 0)
      (nth 1 res)
      ($error "Numerical integration failed with error code" (nth 4 res))))

(defun nintegrate-simp (x y z)
  (declare (ignore y))
  (let* ((arg (simpcheck (nth 1 x) z))
	 (var (simpcheck (nth 2 x) z))
	 (low (simpcheck (nth 3 x) z))
	 (high (simpcheck (nth 4 x) z)))
    (unless (equal high '$inf)
      (setq high ($float high)))
    (if (equal low '((mtimes simp) -1 $inf))
	(setq low '$minf))
    (unless (equal low '$minf)
      (setq low ($float low)))
    (cond ((and (equal low '$minf)
		(equal high '$inf))
	   (check-result ($quad_qagi arg var 0 '$both)))
	  ((and (equal low '$minf)
		($floatnump high))
	   ($first ($quad_qagi arg var high '$minf)))
	  ((and ($floatnump low)
		(equal high '$inf))
	   (check-result ($quad_qagi arg var low '$inf)))
	  ((and ($floatnump low)
		($floatnump high)
		(if (= low high)
		    0d0
		    (check-result ($quad_qags arg var low high)))))
	  (t
	   (list '(%nintegrate simp) arg var (nth 3 x) (nth 4 x))))))
