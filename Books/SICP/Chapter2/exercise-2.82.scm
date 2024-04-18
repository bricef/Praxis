#lang racket
(require "../utils.scm")
(require "../dispatch-table.scm")
(require "./arithmetic-operations.scm")


;   Exercise 2.82
;   =============
;
;   Show how to generalize apply-generic to handle coercion in the general
;   case of multiple arguments.  One strategy is to attempt to coerce all
;   the arguments to the type of the first argument, then to the type of the
;   second argument, and so on.  Give an example of a situation where this
;   strategy (and likewise the two-argument version given above) is not
;   sufficiently general.  (Hint: Consider the case where there are some
;   suitable mixed-type operations present in the table that will not be
;   tried.)
;
;   ------------------------------------------------------------------------
;   [Exercise 2.82]: http://sicp-book.com/book-Z-H-18.html#%_thm_2.82
;   2.5.2 Combining Data of Different Types - p201
;   ------------------------------------------------------------------------

(module* main #f
  (title "Exercise 2.82")

  (assertequal? "We can use apply-generic with 3 arguments when a definition has been provided."
    6
    (apply-generic 'add 1 2 3))



  (assert "converters-for will return identity functions when the types are the same"
    (let*
      [(xs '(1 2 3))
       (converters (converters-for 'scheme-number xs))
       (converted (map (λ (f v) (f v)) converters xs))]
      (equal? converted xs)))

  (assertequal? "converters-for will return nil if no elements can be converted"
    nil
    (converters-for 'weirdo '(1 2 3)))

  (assertequal? "converters-for will return nil if an elements cannot be converted"
    nil
    (converters-for 'scheme-number '(1 (make-rational 2 1) 3)))


  (put-coercion 'scheme-number 'complex
    (λ (s) (make-complex-from-real-imag s 0)))

  (assertequal? "converters-for will find the appropriate converters for the first element"
    (list
      (make-complex-from-real-imag 1 2)
      (make-complex-from-real-imag 2 0)
      (make-complex-from-real-imag 3 0))
    (let*
      [(xs (list (make-complex-from-real-imag 1 2) 2 3))
       (converters (converters-for 'complex xs))]
      (map (λ (f v) (f v)) converters xs)))

  (assertequal? "converters-for will find the appropriate converters for the second element"
    (list
     (make-complex-from-real-imag 2 0)
     (make-complex-from-real-imag 1 2)
     (make-complex-from-real-imag 3 0))
    (let*
      [(xs (list 2 (make-complex-from-real-imag 1 2) 3))
       (converters (converters-for 'complex xs))]
      (map (λ (f v) (f v)) converters xs)))

  (assertequal? "converters-for will find the appropriate converters for the third element"
    (list
      (make-complex-from-real-imag 2 0)
      (make-complex-from-real-imag 3 0)
      (make-complex-from-real-imag 1 2))
    (let*
      [(xs (list 2  3 (make-complex-from-real-imag 1 2)))
       (converters (converters-for 'complex xs))]
      (map (λ (f v) (f v)) converters xs)))

  (assertequal? "Applying generically with forced coercion of elements 2 and 3 works."
    (make-complex-from-real-imag 5 2)
    (apply-generic 'add (make-complex-from-real-imag 1 2) 2 2))

  (assertequal? "Applying generically with forced coercion of elements 1 and 3 works."
    (make-complex-from-real-imag 5 2)
    (apply-generic 'add 2 (make-complex-from-real-imag 1 2) 2))

  (assertequal? "Applying generically with forced coercion of elements 1 and 2 works."
    (make-complex-from-real-imag 5 2)
    (apply-generic 'add 2 2 (make-complex-from-real-imag 1 2)))

  (newline)
  (Q: "Give an example where this strategy will fail.")
  (A: "There are two cases in which our chosen strategy will fail to coerce the arguments
appropriately.

Firstly, our procedure will fail if all arguments could be coerced to another type
to carry out the procedure, but when none of the arguments are actually of that type.
So if we had a proc A with type signature A->A->A and we had the arguments of type B,B,C
where the B->A amd C->A procs were defined, this would still fail even though it is
possible to fullfill the request.

Secondly, if we have a procedure A with signature B->B->C, and we provide B,B,D where the
coercions D->C exist, then we will also fail to find the matching procedure."))














  ;
  ;(assertequal? "We can coerce the arguments to the type of the first arguments"
  ;  (make-rational 11 2)
  ;  (apply-generic 'add (make-rational 1 2) 2 3))
