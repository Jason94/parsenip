(in-package #:parsenip/benchmarks)

(defun %write-benchmark-csv (results pathname)
  (with-open-file (out pathname
                       :direction :output
                       :if-exists :supersede
                       :if-does-not-exist :create)
    (format out "benchmark,metric,samples,total,minimum,maximum,median,average,deviation~%")
    (maphash
     (lambda (bench metrics)
       (dolist (m metrics)
         (destructuring-bind (metric &rest stats) m
           (format out "~A,~A,~A,~A,~A,~A,~A,~A,~A~%"
                   bench metric
                   (getf stats :samples)
                   (float (getf stats :total))
                   (float (getf stats :minimum))
                   (float (getf stats :maximum))
                   (float (getf stats :median))
                   (float (getf stats :average))
                   (float (getf stats :deviation))))))
     results)))

(defun run-ci
    (&optional
       (pathname
        (asdf:system-relative-pathname
         "parsenip/benchmarks"
         "benchmarks/parsenip.csv")))
  (let ((results
          (run-package-benchmarks
           :package :parsenip/benchmarks
           :verbose t)))
    (%write-benchmark-csv results pathname)
    (format t "Wrote benchmark results to ~A~%" pathname)
    results))

(export 'run-ci)
