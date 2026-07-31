(defpackage :parsenip/tests/sources
  (:use #:coalton #:coalton-prelude #:coalton-testing
   #:parsenip
   #:parsenip/sources
   )
  (:local-nicknames
   (:it #:coalton/iterator)
   ))
(in-package :parsenip/tests/sources)

(named-readtables:in-readtable coalton:coalton)

(fiasco:define-test-package #:parsenip/tests/sources-fiasco)
(coalton-fiasco-init #:parsenip/tests/sources-fiasco)

(coalton-toplevel
  (define-type-alias (StepRet :t :c) (Tuple (Optional :t) (Optional :c)))
  
  (declare step-token (StepRet :t :c -> Optional :t))
  (define step-token fst)

  (declare step-cursor (StepRet :t :c -> Optional :c))
  (define step-cursor snd))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;          Buffered Source          ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-test test-buffered-source-step-upto-eof ()
  (let data = (it:into-iter "a"))
  (let bsource = (new-buffered-source ƒ.(it:next! data)))
  (let result = (step bsource (initial-cursor bsource)))
  (is (== (Some #\a) (step-token result)))
  (is (== (Some 1) (step-cursor result))))

(define-test test-buffered-source-step-at-eof ()
  (let data = (it:into-iter " "))
  (let bsource = (new-buffered-source ƒ.(it:next! data)))
  (let c = (step bsource (initial-cursor bsource)))
  (is (== (Some 1)
          (step-cursor c)))
  (match c
    ((Tuple _ (Some c))
     (let result = (step bsource c))
     (is (none? (step-token result)))
     (values))
    (_
     (values))))
