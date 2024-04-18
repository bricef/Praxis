#lang racket
(require (except-in "utils.scm" square))
(provide (all-defined-out))



;;;-----------
;;;from section 3.3.3 for section 2.4.3
;;; to support operation/type table for data-directed dispatch

(define (assoc key records)
  (cond ((null? records) false)
        ((equal? key (caar records)) (car records))
        (else (assoc key (cdr records)))))

(define (make-table)
  (let [[local-table (list '(*table*))]]
    (define (lookup key-1 key-2)
      (define (inner in-table)
        (cond
          [(empty? in-table) #f]
          [(equal? (first (first in-table)) (list key-1 key-2))
           (second (first in-table))]
          [else (inner (rest in-table))]))

      (inner local-table))
    (define (insert! key-1 key-2 value)
      (if (lookup key-1 key-2) (error "Cannot overwrite existing key")
          (set! local-table (cons (list (list key-1 key-2) value) local-table))))
    (define (show)
      (prn local-table))
    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc!) insert!)
            ((eq? m 'show) show)
            (else (error "Unknown operation -- TABLE" m))))
    dispatch))

(define operation-table (make-table))
(define get (operation-table 'lookup-proc))
(define put (operation-table 'insert-proc!))

(define coercion-table (make-table))
(define get-coercion (coercion-table 'lookup-proc))
(define put-coercion (coercion-table 'insert-proc!))



; for type in type-tags, find converters to that type for the others
; for the first where all converters are present, try to get the op from the table
; noop? then move onto the next eleemt

(define (converters-for type xs)
  (define (inner ys)
    (if (empty? ys) nil
      (let*
        [(elem (first ys))
         (same-type (equal? (type-tag elem) type))
         (identity (λ (x) x))
         (coercer (get-coercion (type-tag elem) type))
         (converter (if same-type identity coercer))]
        (if converter
          (cons converter (converters-for type (rest ys)))
          nil))))
  (let* [(res (inner xs))
         (all-converted (= (length xs) (length res)))]
    (if all-converted res nil)))


(define (apply-generic op . args)
  ;(prn 'apply-generic op args)
  (let*
    [(type-tags (map type-tag args))
     (proc (get op type-tags))
     (procargs (map contents args))]
    (cond
        [proc (apply proc procargs)]
        [else
          (let*
            [(largs (length args))
             (possible-convertions (map (λ (t) (converters-for t args)) type-tags))
             (possible-procs (map (λ (t) (get op (repeat t largs))) type-tags))
             (procs-and-convertions (zip possible-procs possible-convertions))
             (possibles (filter (λ (pcs) (and (first pcs) (not (empty? (second pcs))))) procs-and-convertions))]
            ;(prn "====================="
            ;  type-tags
            ;  possible-convertions
            ;  possible-procs
            ;  procs-and-convertions
            ;  possibles)
            (if (not (empty? possibles))
              (let*
                [(match (first possibles))
                 (proc (first match))
                 (converters (second match))
                 (converted (map (λ (ca) ((first ca) (second ca))) (zip converters args)))]
                (apply proc converted))
              (error "No method for these types -- APPLY-GENERIC" (list op type-tags))))])))


(define (attach-tag type-tag contents)
  (cond
    [(number? contents) contents]
    [else (cons type-tag contents)]))

(define (type-tag datum)
  (cond [(pair? datum) (car datum)]
        [(number? datum) 'scheme-number]
      (error "Bad tagged datum -- TYPE-TAG" datum)))

(define (contents datum)
  ;(prn datum "")
  (cond
    [(number? datum) datum]
    [(and (list? datum) (equal? 2 (length datum))) (first (cdr datum))]
    [(pair? datum) (cdr datum)]
    [else (error "Bad tagged datum -- CONTENTS" datum)]))


(module* main #f
  (assert "Nothing in an empty table" (not (get 'a 'b)))
  (void (put 'a 'b 123))
  (assertequal? "We can lookup what we inserted" 123 (get 'a 'b)))
