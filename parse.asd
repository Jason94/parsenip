(asdf:defsystem "parsenip"
  :defsystem-depends-on ("coalton-asdf")
  :depends-on ("serapeum" "coalton" "coalton-io")
  :pathname "src/"
  :serial t
  :components
  (
    (:ct-file "main")
  )
)
