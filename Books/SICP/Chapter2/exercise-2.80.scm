#lang racket
(require "../utils.scm")
(require "../dispatch-table.scm")
(require "./arithmetic-operations.scm")

;   Exercise 2.80
;   =============
;
;   Define a generic predicate =zero? that tests if its argument is zero,
;   and install it in the generic arithmetic package.  This operation should
;   work for ordinary numbers, rational numbers, and complex numbers.
;
;   ------------------------------------------------------------------------
;   [Exercise 2.80]: http://sicp-book.com/book-Z-H-18.html#%_thm_2.80
;   2.5.1 Generic Arithmetic Operations - p193
;   ------------------------------------------------------------------------

(module* main #f
  (title "Exercise 2.80")

  (assert "We can tell when a scheme number is 0"
    (=zero? 0.0))
  (assert "We can tell when a scheme number is not 0"
    (not (=zero? 1.0)))

  (assert "We can tell when a rational number is 0"
    (=zero? (make-rational 0 1)))
  (assert "We can tell when a rational number is not 0"
    (not (=zero? (make-rational 1 3))))

  (assert "We can tell when a complex number is 0"
    (=zero? (make-complex-from-real-imag 0 0)))
  (assert "We can tell when a complex number is not 0"
    (not (=zero? (make-complex-from-real-imag 1 3))))
)
