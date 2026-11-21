(in-package #:parsenip/benchmarks)

(define-benchmark parse-bytes-bulk ()
  (declare (optimize speed))
  (loop :repeat *count*
        :do (with-benchmark-sampling
              (c:coalton
                (bytes:parse-expr-file-bulk
                  (c:lisp (-> c:String) ()
                    *filename*)))))
  (report trivial-benchmark::*current-timer*))
