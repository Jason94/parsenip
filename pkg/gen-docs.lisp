(defpackage #:parsenip/docs
  (:use #:cl)
  (:export #:write-docs))

(in-package #:parsenip/docs)

(defun write-docs (&key
                     (pathname (merge-pathnames #p"docs/index.html"
                                               (asdf:system-source-directory "parsenip")))
                     (packages (mapcar
                                (lambda (p)
                                  (coalton/doc/model::make-coalton-package
                                   (find-package p)
                                   :reexported-symbols t))
                                (list
                                 'parsenip/sources
                                 'parsenip
                                 'parsenip/text
                                 )))
                     (remote-path "https://github.com/Jason94/parsenip/tree/master"))
  (coalton/doc:write-documentation
   pathname
   packages
   :local-path (namestring (asdf:system-source-directory "parsenip"))
   :remote-path remote-path
   :backend :html))
