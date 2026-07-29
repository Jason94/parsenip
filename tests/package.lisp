(defpackage #:parsenip/tests
  (:use #:coalton #:coalton-prelude #:coalton-testing)
  (:export #:run-tests))
(in-package #:parsenip/tests)

(named-readtables:in-readtable coalton:coalton)

(fiasco:define-test-package #:parsenip/fiasco-test-package)

(coalton-fiasco-init #:parsenip/fiasco-test-package)

(cl:defun run-tests ()
  (fiasco:run-package-tests
   :packages '(
               #:parsenip/tests/sources-fiasco
               #:parsenip/tests/core-fiasco
               )
   :interactive cl:t))
