(asdf:defsystem "trivial-loop-extensions"
  :description "A portable implementations of LOOP iteration path extensions"
  :license "MIT"
  :author ("Tarn W. Burton")
  :maintainer "Tarn W. Burton"
  ;:version (:read-file-form "version.sexp")
  :homepage "https://github.com/yitzchak/trivial-loop-extensions"
  :bug-tracker "https://github.com/yitzchak/trivial-loop-extensions/issues"
  :depends-on ()
  :components ((:module code
                :serial t
                :components ((:file "packages")
                             (:file "compatibility")
                             (:file "stream")))))
