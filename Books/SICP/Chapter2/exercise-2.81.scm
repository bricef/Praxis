#lang racket
(require "../utils.scm")
(require "../dispatch-table.scm")
(require "./arithmetic-operations.scm")


;   Exercise 2.81
;   =============
;
;   Louis Reasoner has noticed that apply-generic may try to coerce the
;   arguments to each other's type even if they already have the same type.
;   Therefore, he reasons, we need to put procedures in the coercion table
;   to "coerce" arguments of each type to their own type.  For example, in
;   addition to the scheme-number->complex coercion shown above, he would
;   do:
;
   (define (scheme-number->scheme-number n) n)
   (define (complex->complex z) z)
   (put-coercion 'scheme-number 'scheme-number
                 scheme-number->scheme-number)
   (put-coercion 'complex 'complex complex->complex)
;
;   a. With Louis's coercion procedures installed, what happens if
;   apply-generic is called with two arguments of type scheme-number or two
;   arguments of type complex for an operation that is not found in the
;   table for those types?  For example, assume that we've defined a generic
;   exponentiation operation:
;
   (define (exp x y) (apply-generic 'exp x y))
;
;   and have put a procedure for exponentiation in the Scheme-number package
;   but not in any other package:
;
  ; ;; following added to Scheme-number package
  ; (put 'exp '(scheme-number scheme-number)
  ;      (lambda (x y) (tag (expt x y)))) ; using primitive expt
;
;   What happens if we call exp with two complex numbers as arguments?
;
;   b. Is Louis correct that something had to be done about coercion with
;   arguments of the same type, or does apply-generic work correctly as is?
;
;   c. Modify apply-generic so that it doesn't try coercion if the two
;   arguments have the same type.
;
;   ------------------------------------------------------------------------
;   [Exercise 2.81]: http://sicp-book.com/book-Z-H-18.html#%_thm_2.81
;   2.5.2 Combining Data of Different Types - p200
;   ------------------------------------------------------------------------

(module* main #f
  (title "Exercise 2.81")
  (Q: "2.81.a What happens if we call a procedure using apply-generic when
A->A coercions are provided but no procedure is available for the types?

For example, calling (apply-generic 'exp complex-1 complex-2) when
complex->complex has been provided but not (exp complex complex).")
  (A:
"If A->A type converters are provided, the apply-generic procedure will loop
forever. this is because it will successfully try to coerce one arg type to
the other and then call itself recursively. However, since this does not change
the types of the application, the problem will persist in the next iteration")

  (Q: "2.81.b Is Louis correct that something had to be done about coercion
with arguments of the same type, or does apply-generic work correctly as is?")

  (A: "Louis is correct. We must handle the case when two arguments have
the same type AND we cannot find a procedure for the arguments. Ideally we would
search for a type that does have the requested operation and coerce both
arguments to that type instead. We could also raise an error.")

 (assert-raises-error "Errors when apply-generic a missing procedure with args of same type."
   (apply-generic 'exp
     (make-complex-from-real-imag 1 2)
     (make-complex-from-real-imag 3 4))))
