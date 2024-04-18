#lang racket
(require "../utils.scm")
(require "../dispatch-table.scm")
(require "./arithmetic-operations.scm")


;   Exercise 2.79
;   =============
;
;   Define a generic equality predicate equ? that tests the equality of two
;   numbers, and install it in the generic arithmetic package.  This
;   operation should work for ordinary numbers, rational numbers, and
;   complex numbers.
;
;   ------------------------------------------------------------------------
;   [Exercise 2.79]: http://sicp-book.com/book-Z-H-18.html#%_thm_2.79
;   2.5.1 Generic Arithmetic Operations - p193
;   ------------------------------------------------------------------------

(module* main #f
  (title "Exercise 2.79")

  (assert "We can compare scheme numbers"
    (equ? 1 1.0))

  (assert "We can compare complex numbers"
    (equ?
      (make-complex-from-real-imag 3 4)
      (make-complex-from-real-imag 3 4)))

  (assert "We can compare rational numbers"
    (equ? (make-rational 2 4) (make-rational 1 2)))


)
