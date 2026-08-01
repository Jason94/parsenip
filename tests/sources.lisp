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
  (let (values t c) = (step bsource (initial-cursor bsource)))
  (is (== (Some #\a) t))
  (is (== (Some 1) c)))

(define-test test-buffered-source-step-at-eof ()
  (let data = (it:into-iter " "))
  (let bsource = (new-buffered-source ƒ.(it:next! data)))
  (let (values t c) = (step bsource (initial-cursor bsource)))
  (is (== (Some 1) c))
  (is (== (Some #\Space) t)))
