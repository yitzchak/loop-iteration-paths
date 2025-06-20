(cl:in-package #:loop-iteration-paths)

#+abcl (require :extensible-sequences)

(defun make-named-variable (name &optional prefix)
  (multiple-value-bind (var varp)
      #+abcl
      (loop::loop-named-var name)
      #+(or ccl cmucl)
      (ansi-loop::named-variable name)
      #+clasp
      (system::named-variable name)
      #+ecl
      (system::loop-named-var name)
      #+sbcl
      (sb-loop::loop-named-var name)
    (cond (varp var)
          (prefix (gensym prefix))
          (t nil))))

(defun add-wrapper (form)
  (push form #+abcl loop::*loop-wrappers*
             #+(or clasp ecl)
             system::*loop-wrappers*
             #+(or ccl cmucl)
             ansi-loop::*loop-wrappers*
             #+sbcl
             (sb-loop::wrappers sb-loop::*loop*)))
             
(defun add-loop-path (names function &rest rest)
  #+abcl
  (apply #'loop::add-loop-path names function loop::*loop-ansi-universe* rest)
  #+(or ccl cmucl)
  (apply #'ansi-loop::add-loop-path names function ansi-loop::*loop-ansi-universe* rest)
  #+(or clasp ecl)
  (apply #'system::add-loop-path names function system::*loop-ansi-universe* rest)
  #+sbcl
  (apply #'sb-loop::add-loop-path names function sb-loop::*loop-ansi-universe* rest))
