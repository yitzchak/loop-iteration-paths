(cl:in-package #:loop-iteration-paths)

(defmacro with-stream-close ((var closep) &body body)
  `(unwind-protect
        (progn ,@body)
     (when (and ,var ,closep)
       (close ,var))))

(defun loop-stream-iteration-path (variable data-type prep-phrases
                                   &key which) 
  (declare (type (member :bytes :characters :lines :objects) which))
  (unless variable
    (setf variable (gensym "VAR")))
  (unless data-type
    (setf data-type
          (ecase which
            (:bytes 'integer)
            (:characters 'character)
            (:lines 'string)
            (:objects t))))
  (loop with stream-var = (make-named-variable :stream "STREAM")
        with stream-form-p = nil
        with close-ref = nil
        with missing-newline-p-var = (when (eq which :lines)
                                       (make-named-variable :missing-newline-p))
        with next-var = (gensym "NEXT")
        with mlp-var = (gensym "MLP")
        for (name value) in prep-phrases
        when (not (eq name :close))
          do (setf stream-form-p t) and
          collect `(,stream-var ,value stream) into bindings
        else when (constantp value)
          do (add-wrapper `(with-stream-close (,stream-var ,value)))
        else
          do (setf close-ref (gensym "CLOSEP"))
             (add-wrapper `(with-stream-close (,stream-var ,close-ref)))
          and collect `(,close-ref ,value) into bindings
        finally (return (list (nconc  `((,next-var nil (or stream ,data-type))
                                        (,mlp-var nil)
                                        (,variable nil ,data-type))
                                      (when missing-newline-p-var
                                        `((,missing-newline-p-var nil)))
                                      (unless stream-form-p
                                        `((,stream-var *standard-input* stream)))
                                      bindings)
                              '()   ;prologue
                              '()   ;pre-test
                              '()   ;parallel steps
                              (ecase which
                                (:bytes
                                 `(eq ,stream-var
                                      (setq ,next-var (read-byte ,stream-var nil ,stream-var))))
                                (:characters
                                 `(eq ,stream-var
                                      (setq ,next-var (read-char ,stream-var nil ,stream-var))))
                                (:lines
                                 `(eq ,stream-var
                                      (multiple-value-setq (,next-var ,mlp-var)
                                        (read-line ,stream-var nil ,stream-var))))
                                (:objects
                                 `(eq ,stream-var
                                      (setq ,next-var (read ,stream-var nil ,stream-var)))))
                              (if missing-newline-p-var
                                  `(,variable ,next-var ,missing-newline-p-var ,mlp-var)
                                  `(,variable ,next-var))))))

(add-loop-path '(:byte :bytes)
               'loop-stream-iteration-path
               :preposition-groups '((:of :in) (:close))
               :inclusive-permitted nil
               :user-data '(:which :bytes))

(add-loop-path '(:character :characters)
               'loop-stream-iteration-path
               :preposition-groups '((:of :in) (:close))
               :inclusive-permitted nil
               :user-data '(:which :characters))

(add-loop-path '(:line :lines)
               'loop-stream-iteration-path
               :preposition-groups '((:of :in) (:close))
               :inclusive-permitted nil
               :user-data '(:which :lines))

(add-loop-path '(:object :objects)
               'loop-stream-iteration-path
               :preposition-groups '((:of :in) (:close))
               :inclusive-permitted nil
               :user-data '(:which :objects))
