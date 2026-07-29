(asdf:defsystem "parsenip"
  :defsystem-depends-on ("coalton-asdf")
  :depends-on ("serapeum" "coalton" "coalton-io")
  :pathname "src/"
  :serial t
  :components
  (
   (:ct-file "sources")
   (:ct-file "main")
   (:ct-file "text")
  )
  :in-order-to ((test-op (test-op "parsenip/tests")))
)

(defsystem "parsenip/tests"
  :author "Jason Walker"
  :license "MIT"
  :depends-on ("parsenip"
               "coalton/testing"
               "fiasco")
  :components ((:module "tests"
                :serial t
                :components
                (
                 (:file "sources")
                 (:file "core")
                 (:file "package")
                 )))
  :perform (test-op (op c)
            (uiop:with-current-directory ((asdf:system-source-directory c))
              (uiop:symbol-call '#:parsenip/tests '#:run-tests))))

(defsystem "parsenip/docs"
  :author "Jason Walker"
  :license "MIT"
  :depends-on ("parsenip" "coalton/doc")
  :pathname "pkg"
  :components ((:file "gen-docs"))
  :description "Generate HTML documentation for parsenip."
  :perform (load-op (op c)
            (uiop:with-current-directory ((asdf:system-source-directory c))
              (uiop:symbol-call '#:parsenip/docs '#:write-docs))))
