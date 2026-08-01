(defpackage :parsenip/tests/utils
  (:use #:coalton #:coalton-prelude
   #:parsenip
   #:parsenip/sources
   )
  (:import-from #:coalton/result
   #:err?)
  (:export
   #:err-cursor
   #:partial-suc-cursor
   #:partial-suc-value))
(in-package :parsenip/tests/utils)

(named-readtables:in-readtable coalton:coalton)
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
