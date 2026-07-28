(defpackage :parsenip/tests/core
  (:use #:coalton #:coalton-prelude #:coalton-testing
   #:parsenip
   #:parsenip/sources
   )
  (:import-from #:coalton/result
   #:err?))
(in-package :parsenip/tests/core)

(named-readtables:in-readtable coalton:coalton)

(fiasco:define-test-package #:parsenip/tests/core-fiasco)
(coalton-fiasco-init #:parsenip/tests/core-fiasco)

(define-test test-eof-matches-and-doesnt-advance ()
  (let result = (parse-source ""
                              (partial (eof))))
  (is (== (Ok (Tuple3 "" 0 Unit))
          result)))

(define-test test-eof-fails-before-eof ()
  (let result = (parse-source " "
                              (partial (eof))))
  (is (err? result)))

(define-test test-flatten-opt-succeedes-doesnt-advance ()
  (let result = (parse-source " "
                              (partial (flatten-opt (pure (Some Unit))))))
  (is (== (Ok (Tuple3 " " 0 Unit))
          result)))

(define-test test-flatten-opt-fails ()
  (let result = (parse-source " "
                              (partial (flatten-opt (pure None)))))
  (is (err? result)))

(define-test test-look-ahead-succeedes-doesnt-advance ()
  (let result = (parse-source "a"
                              (partial (look-ahead (next)))))
  (is (== (Ok (Tuple3 "a" 0 #\a))
          result)))

(define-test test-peek-matches-and-doesnt-advance ()
  (let result = (parse-source "a"
                              (partial (peek))))
  (is (== (Ok (Tuple3 "a" 0 #\a))
          result)))

(define-test test-peek-fails-at-eof ()
  (let result = (parse-source ""
                              (partial (peek))))
  (is (err? result)))

(define-test test-peek-backtracks-on-fail ()
  (let result = (parse-source ""
                              (partial (alt (peek)
                                            (pure #\z)))))
  (is (== (Ok (Tuple3 "" 0 #\z))
          result)))

(define-test test-next-matches-and-advances ()
  (let result = (parse-source "a"
                              (partial (next))))
  (is (== (Ok (Tuple3 "a" 1 #\a))
          result)))

(define-test test-next-fails-at-eof ()
  (let result = (parse-source ""
                              (partial (next))))
  (is (err? result)))

(define-test test-next-backtracks-on-fail ()
  (let result = (parse-source ""
                              (partial (alt (next)
                                            (pure #\z)))))
  (is (== (Ok (Tuple3 "" 0 #\z))
          result)))
