(cl:in-package #:trivial-loop-extensions)

(defun make-named-variable (name &optional prefix)
  (multiple-value-bind (var varp)
      #+(or clasp ecl mkcl)
      (system::named-variable name)
      #+sbcl
      (sb-loop::loop-named-var name)
    (cond (varp var)
          (prefix (gensym prefix))
          (t nil))))

(defun add-wrapper (form)
  (push form #+sbcl (sb-loop::wrappers sb-loop::*loop*)))
             
(defun add-loop-path (names function &rest rest)
  #+abcl
  (apply #'loop:add-loop-path names function loop:*loop-ansi-universe rest)
  #+ccl
  (apply #'ansi-loop:add-loop-path names function ansi-loop:*loop-ansi-universe rest)
  #+(or clasp ecl mkcl)
  (apply #'system:add-loop-path names function system:*loop-ansi-universe rest)
  #+sbcl
  (apply #'sb-loop::add-loop-path names function sb-loop::*loop-ansi-universe* rest))
