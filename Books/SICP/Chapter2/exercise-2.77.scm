#lang racket
(require"../utils.scm" )
(require "../dispatch-table.scm")
(require "./arithmetic-operations.scm")



;   Exercise 2.77
;   =============
;
;   Louis Reasoner tries to evaluate the expression (magnitude z) where z is
;   the object shown in figure [2.24].  To his surprise, instead of the
;   answer 5 he gets an error message from apply-generic, saying there is no
;   method for the operation magnitude on the types (complex). He shows this
;   interaction to Alyssa P. Hacker, who says "The problem is that the
;   complex-number selectors were never defined for complex numbers, just
;   for polar and rectangular numbers.  All you have to do to make this work
;   is add the following to the complex package:"
;
;   (put 'real-part '(complex) real-part)
;   (put 'imag-part '(complex) imag-part)
;   (put 'magnitude '(complex) magnitude)
;   (put 'angle '(complex) angle)
;
;   Describe in detail why this works.  As an example, trace through all the
;   procedures called in evaluating the expression (magnitude z) where z is
;   the object shown in figure [2.24].  In particular, how many times is
;   apply-generic invoked?  What procedure is dispatched to in each case?
;
;   ------------------------------------------------------------------------
;   [Exercise 2.77]: http://sicp-book.com/book-Z-H-18.html#%_thm_2.77
;   [Figure 2.24]:   http://sicp-book.com/book-Z-H-18.html#%_fig_2.24
;   2.5.1 Generic Arithmetic Operations - p192
;   ------------------------------------------------------------------------


(module* main #f
  (title "Exercise 2.77")

(prn "Louis Reasoner tries to evaluate the expression (magnitude z) where z is
the object shown in figure [2.24].  To his surprise, instead of the
answer 5 he gets an error message from apply-generic, saying there is no
method for the operation magnitude on the types (complex). He shows this
interaction to Alyssa P. Hacker, who says 'The problem is that the
complex-number selectors were never defined for complex numbers, just
for polar and rectangular numbers.  All you have to do to make this work
is add the following to the complex package:''

    (put 'real-part '(complex) real-part)
    (put 'imag-part '(complex) imag-part)
    (put 'magnitude '(complex) magnitude)
    (put 'angle '(complex) angle)
")

  (define z (list 'complex 'rectangular (cons 3 4)))

(Q: "Describe in detail why this works.")
(A: "Adding the following:

    (put 'real-part '(complex) real-part)
    (put 'imag-part '(complex) imag-part)
    (put 'magnitude '(complex) magnitude)
    (put 'angle '(complex) angle);...

To the complex number package will allow us to call
`(magnitude z)` because the complex package will defer
to the underlying complex number implementation for the
functions.

We can see this would be the case because the functions
have already been generically defined:

    (define (real-part z) (apply-generic 'real-part z))
    (define (imag-part z) (apply-generic 'imag-part z))
    (define (magnitude z) (apply-generic 'magnitude z))

In the arithmetic package. Without adding this
specification to the complex package, a generical call
to `magnitude` on a complex number will fail, as no
function has been associated to `magnitude` in for `complex`
in the dispatch table.
")

(Q: "Trace through all the procedures called in evaluating the
expression (magnitude z) In particular, how many times is
apply-generic invoked?  What procedure is dispatched to in each case?")

(A: "
1. (magnitude (list complex rectangular (cons 3 4)))
  ; arithmetic-operations/magnitude

2. (apply-generic 'magnitude (list complex rectangular (cons 3 4)))

3. (magnitude z)
  ; complex/magnitude

4. (apply-generic 'magnitude (list rectangular (cons 3 4)))

5. (magnitude (cons 3 4))
  ;rectangular/magnitude

As seen above, apply-generic is called twice, once for each type tag.
For the first tag (`complex`), the magnitude procedure called is the
complex package's magnitude procedure, which itself calls the
`apply-generic` procedure. The next time `magnitude` is called, it
is the rectangular package's magnitude procedure, which gives the
correct answer:")

  (magnitude z)
)
