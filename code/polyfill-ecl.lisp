(cl:in-package #:si)

(defun loop-tassoc (kwd alist)
  (and (symbolp kwd) (assoc kwd alist :test #'string=)))

(defun loop-named-var (name)
  (let ((tem (loop-tassoc name *loop-named-variables*)))
    (declare (list tem))
    (cond ((null tem) (values (gensym) nil))
          (t (setq *loop-named-variables* (delete tem *loop-named-variables*))
             (values (cdr tem) t)))))

(defun add-loop-path (names function universe &key preposition-groups inclusive-permitted user-data)
  (unless (listp names)
    (setq names (list names)))
  (let ((ht (loop-universe-path-keywords universe))
        (lp (make-loop-path
              :names (mapcar #'symbol-name names)
              :function function
              :user-data user-data
              :preposition-groups (mapcar #'(lambda (x) (if (listp x) x (list x))) preposition-groups)
              :inclusive-permitted inclusive-permitted)))
    (dolist (name names) (setf (gethash (symbol-name name) ht) lp))
    lp))
