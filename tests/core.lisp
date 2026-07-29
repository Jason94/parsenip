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

(coalton-toplevel
  (declare err-cursor (ParseResult :c :r -> Optional :c))
  (define (err-cursor r)
    (match r
      ((Ok _)
       None)
      ((Err (Tuple3 c _ _))
       (Some c))))

  (declare partial-suc-cursor (ParseResult :c (Tuple :c :r) -> Optional :c))
  (define (partial-suc-cursor r)
    (match r
      ((Err _)
       None)
      ((Ok (Tuple c _))
       (Some c))))

  (declare partial-suc-value (ParseResult :c (Tuple :c :r) -> Optional :r))
  (define (partial-suc-value r)
    (match r
      ((Err _)
       None)
      ((Ok (Tuple _ v))
       (Some v)))))

(define-test test-eof-matches-and-doesnt-advance ()
  (let result = (parse-source ""
                              (partial (eof))))
  (is (== (Ok (Tuple 0 Unit))
          result)))

(define-test test-eof-fails-before-eof ()
  (let result = (parse-source " "
                              (partial (eof))))
  (is (err? result)))

(define-test test-flatten-opt-succeedes-doesnt-advance ()
  (let result = (parse-source " "
                              (partial (flatten-opt (pure (Some Unit))))))
  (is (== (Ok (Tuple 0 Unit))
          result)))

(define-test test-flatten-opt-fails ()
  (let result = (parse-source " "
                              (partial (flatten-opt (pure None)))))
  (is (err? result)))

(define-test test-look-ahead-succeedes-doesnt-advance ()
  (let result = (parse-source "a"
                              (partial (look-ahead (next)))))
  (is (== (Ok (Tuple 0 #\a))
          result)))

(define-test test-peek-matches-and-doesnt-advance ()
  (let result = (parse-source "a"
                              (partial (peek))))
  (is (== (Ok (Tuple 0 #\a))
          result)))

(define-test test-peek-fails-at-eof ()
  (let result = (parse-source ""
                              (partial (peek))))
  (is (err? result)))

(define-test test-peek-backtracks-on-fail ()
  (let result = (parse-source ""
                              (partial (alt (peek)
                                            (pure #\z)))))
  (is (== (Ok (Tuple 0 #\z))
          result)))

(define-test test-next-matches-and-advances ()
  (let result = (parse-source "a"
                              (partial (next))))
  (is (== (Ok (Tuple 1 #\a))
          result)))

(define-test test-next-fails-at-eof ()
  (let result = (parse-source ""
                              (partial (next))))
  (is (err? result)))

(define-test test-next-backtracks-on-fail ()
  (let result = (parse-source ""
                              (partial (alt (next)
                                            (pure #\z)))))
  (is (== (Ok (Tuple 0 #\z))
          result)))

(define-test test-many-till-p-fail-at-0-backtracks ()
  (let result = (parse-source "bbb"
                              (many-till (next-token #\a)
                                         (next-token #\z))))
  (let _ = (the (ParseResult UFix (Vector Char)) result))
  (is (== (Some 0)
          (err-cursor result))))

(define-test test-many-till-end-succeed-end-advances-cursor ()
  (let result = (parse-source "aab"
                              (partial (many-till (next-token #\a)
                                                  (next-token #\b)))))
  (let _ = (the (ParseResult UFix (Tuple UFix (Vector Char))) result))
  (is (== (Some 3)
          (partial-suc-cursor result)))
  (is (== (Some [#\a #\a])
          (partial-suc-value result))))
