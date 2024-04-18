#lang racket
(require "../utils.scm")
(require "../dispatch-table.scm")
(require "./arithmetic-operations.scm")


;   Exercise 2.83
;   =============
;
;   Suppose you are designing a generic arithmetic system for dealing with
;   the tower of types shown in figure [2.25]: integer, rational, real,
;   complex.  For each type (except complex), design a procedure that raises
;   objects of that type one level in the tower.  Show how to install a
;   generic raise operation that will work for each type (except complex).
;
;   ------------------------------------------------------------------------
;   [Exercise 2.83]: http://sicp-book.com/book-Z-H-18.html#%_thm_2.83
;   [Figure 2.25]:   http://sicp-book.com/book-Z-H-18.html#%_fig_2.25
;   2.5.2 Combining Data of Different Types - p201
;   ------------------------------------------------------------------------

(define (integer->rational n)
  (make-rational (contents n) 1))

(define (rational->real n) ; guaranteed rational
  ;(prn ":::rational->real " n)
  (make-real (/ (apply-generic 'numer n) (apply-generic 'denom n))))

(define (real->complex n)
  ;(prn ":::real->complex" n)
  (make-complex-from-real-imag (contents n) 0))


(define (bare-rational->real n)
  (make-real (/ (car n) (cdr n))))

(put 'raise '(integer) integer->rational)
(put 'raise '(rational) bare-rational->real)
(put 'raise '(real) real->complex)



(define (make-integer n)
  (if (= 0.0 (- n (floor n)))
    (cons 'integer n) ; using cons directly cause the attach-tag
                      ; will bail for scheme numbers
    (error "Must supply an integer")))

(define (make-real n)
  (cons 'real (* 1.0 n))) ; rough and ready

;(define (make-rational a b)
;  (cons 'rational (cons a b)))

(module* main #f
  (title "Exercise 2.83")

  (assertequal? "Can convert integer to rational"
    (make-rational 1 1)
    (integer->rational (make-integer 1)))

  (assertequal? "Can convert rational to real"
    (make-real 0.5)
    (rational->real (make-rational 1 2)))

  (assertequal? "Can convert a real into a complex"
    (make-complex-from-real-imag 0.5 0)
    (apply-generic 'raise (make-real 0.5)))

  (assert-raises-error "Can't make an integer from a float"
    (make-integer 2.3))

  (assertequal? "An integer has an 'integer tag"
    'integer
    (type-tag (make-integer 1)))

  (assertequal? "An integer has a value"
    1
    (contents (make-integer 1)))

  (assertequal? "A Rational has a 'rational tag"
    'rational
    (type-tag (make-rational 1 2)))

  (assertequal? "Can make a complex from a real"
    (make-complex-from-real-imag 0.5 0)
    (apply-generic 'raise (make-real 0.5)))

  (assertequal? "Can make a real from a rational"
    (make-real 0.5)
    (apply-generic 'raise (make-rational 1 2))))
