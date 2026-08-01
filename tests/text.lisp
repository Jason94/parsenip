(defpackage :parsenip/tests/text
  (:use #:coalton #:coalton-prelude #:coalton-testing
   #:parsenip
   #:parsenip/sources
   #:parsenip/text
   #:parsenip/tests/utils
   )
  (:import-from #:coalton/result
   #:err?))
(in-package :parsenip/tests/text)

(named-readtables:in-readtable coalton:coalton)

(fiasco:define-test-package #:parsenip/tests/text-fiasco)
(coalton-fiasco-init #:parsenip/tests/text-fiasco)

(define-test test-next-ufix-matches-int ()
  (let result = (parse-source "123foo"
                              (partial (next-ufix))))
  (is (== (Some 3)
          (partial-suc-cursor result)))
  (is (== (Some 123)
          (partial-suc-value result))))

(define-test test-next-ufix-eof ()
  (let result = (parse-source "123"
                              (partial (next-ufix))))
  (is (== (Some 3)
          (partial-suc-cursor result)))
  (is (== (Some 123)
          (partial-suc-value result))))
         
