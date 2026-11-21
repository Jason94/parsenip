(trivial-benchmark:define-benchmark-package
    #:parsenip/benchmarks
  (:local-nicknames
   (:c #:coalton)
   (:chars #:parsenip/examples/benchmark)
   (:bytes #:parsenip/examples/benchmark-bytes)))
