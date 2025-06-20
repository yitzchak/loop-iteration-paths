(asdf:defsystem "loop-iteration-paths"
  :description "A portable implementations of LOOP iteration path extensions"
  :license "MIT"
  :author ("Tarn W. Burton")
  :maintainer "Tarn W. Burton"
  ;:version (:read-file-form "version.sexp")
  :homepage "https://github.com/yitzchak/loop-iteration-paths"
  :bug-tracker "https://github.com/yitzchak/loop-iteration-paths/issues"
  :depends-on ()
  :in-order-to ((asdf:test-op (asdf:test-op "loop-iteration-paths/test")))
  :components ((:module code
                :serial t
                :components ((:file "packages")
                             (:file "polyfill-ecl" :if-feature :ecl)
                             (:file "compatibility"
                              :if-feature (:or :abcl :ccl :clasp :cmucl :ecl :sbcl))
                             (:file "elements"
                              :if-feature (:or :abcl :ccl :clasp :cmucl :ecl :sbcl))
                             (:file "stream"
                              :if-feature (:or :abcl :ccl :clasp :cmucl :ecl :sbcl))))))

(asdf:defsystem "loop-iteration-paths/test"
  :description "Test system"
  :license "MIT"
  :author ("Tarn W. Burton")
  :maintainer "Tarn W. Burton"
  ;:version (:read-file-form "version.sexp")
  :homepage "https://github.com/yitzchak/loop-iteration-paths"
  :bug-tracker "https://github.com/yitzchak/loop-iteration-paths/issues"
  :depends-on ("loop-iteration-paths"
               "nontrivial-gray-streams"
               "parachute")
  :if-feature (:or :abcl :ccl :clasp :cmucl :ecl :sbcl)
  :perform (asdf:test-op (op c)
             (defparameter cl-user::*exit-on-test-failures* t)
             (uiop:symbol-call :parachute :test :loop-iteration-paths/test))
  :components ((:module code
                :pathname "code/test/"
                :serial t
                :components ((:file "packages")
                             (:file "utility")
                             (:file "elements")
                             (:file "stream")))))
