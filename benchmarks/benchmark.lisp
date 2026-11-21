(in-package #:parsenip/benchmarks)

(defparameter *count* 20)

(defparameter *filename*
  (namestring
   (asdf:system-relative-pathname
    "parsenip/benchmarks"
    "benchmarks/big-example.txt")))

(define-benchmark parse-char-stream ()
  (declare (optimize speed))
  (loop :repeat *count*
        :do (with-benchmark-sampling
              (c:coalton
                (chars:parse-expr-file
                  (c:lisp (-> c:String) ()
                    *filename*)))))
  (report trivial-benchmark::*current-timer*))

(define-benchmark parse-chars-bulk ()
  (declare (optimize speed))
  (loop :repeat *count*
        :do (with-benchmark-sampling
              (c:coalton
                (chars:parse-expr-file-bulk
                  (c:lisp (-> c:String) ()
                    *filename*)))))
  (report trivial-benchmark::*current-timer*))
