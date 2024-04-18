#lang racket
(require "../utils.scm")
(require "./exercise-2.46.scm")

(provide (all-defined-out))

; Exercise 2.47: 
; 
; Here are two possible constructors for frames:
; 
;     (define (make-frame origin edge1 edge2) (list origin edge1 edge2))
; 
;     (define (make-frame origin edge1 edge2) (cons origin (cons edge1 edge2)))
; 
; For each constructor supply the appropriate 
; selectors to produce an implementation for frames.
; 
; origin-frame, edge1-frame, and edge2-frame

(define (frame origin edge1 edge2) 
	(list origin edge1 edge2))

(define (origin-frame f)
	(first f))

(define (edge1-frame f)
	(second f))

(define (edge2-frame f)
	(third f))

(define (frameB origin edge1 edge2) 
	(cons origin (cons edge1 edge2)))

(define (origin-frameB f)
	(car f))

(define (edge1-frameB f)
	(car (cdr  f)))

(define (edge2-frameB f)
	(cdr (cdr f)))


(let* 
	(
		(A (frame (make-vect 1 2) (make-vect 3 4) (make-vect 5 6)))
		(B (frameB (make-vect 1 2) (make-vect 3 4) (make-vect 5 6)))
	)
	(assert "we can get the origin of frames type A & B" 
		(all-equal? (origin-frame A) (origin-frameB B) (make-vect 1 2)))
	(assert "we can get the first edge of frames type A & B" 
		(all-equal? (edge1-frame A) (edge1-frameB B) (make-vect 3 4)))
	(assert "we can get the second edge of frames type A & B" 
		(all-equal? (edge2-frame A) (edge2-frameB B) (make-vect 5 6)))
	
)
