(cl:in-package #:loop-iteration-paths)

(defun loop-elements-iteration-path (variable data-type prep-phrases)
  #+(or abcl clasp sbcl)
  (loop with from-end-ref
        with start-ref = 0
        with end-ref
        with seq-ref
        with it = (gensym "IT")
        with lim = (gensym "LIMIT")
        with f-e = (gensym "FROM-END")
        with step = (gensym "STEP")
        with endp = (gensym "ENDP")
        with get = (gensym "GET")
        with set = (gensym "SET")
        with index = (gensym "INDEX")
        with index-var = (make-named-variable :index)
        for (name value) in prep-phrases
        when (eq name :from-end)
          do (setf from-end-ref (gensym "FROM-END"))
          and collect `(,from-end-ref ,value) into bindings
        else when (eq name :start)
          do (setf start-ref (gensym "START"))
          and collect `(,start-ref ,value fixnum) into bindings
        else when (eq name :end)
          do (setf end-ref (gensym "END"))
          and collect `(,end-ref ,value fixnum) into bindings
        else
          do (setf seq-ref (gensym "SEQ"))
          and collect `(,seq-ref ,value sequence) into bindings
        finally (return `(((,variable nil ,data-type)
                           (,it nil)
                           (,lim nil)
                           (,f-e nil)
                           (,step nil)
                           (,endp nil)
                           (,get nil)
                           (,set nil)
                           (,index nil)
                           ,@(when index-var
                               `((,index-var 0 fixnum)))
                           ,@bindings)
                          ((multiple-value-setq (,it ,lim ,f-e ,step ,endp ,get ,set ,index)
                             (sequence:make-sequence-iterator ,seq-ref :start ,start-ref
                                                                       :end ,end-ref
                                                                       :from-end ,from-end-ref)))
                          (funcall ,endp ,seq-ref ,it ,lim ,f-e)
                          ()
                          ()
                          (,variable (funcall ,get ,seq-ref ,it)
                           ,@(when index-var
                               `(,index-var (funcall ,index ,seq-ref ,it)))
                           ,it (funcall ,step ,seq-ref ,it ,f-e)))))
  #-(or abcl clasp sbcl)
  (loop with from-end-ref
        with start-ref = 0
        with end-ref
        with seq-ref
        with it-var = (gensym "IT")
        with limit-var = (gensym "LIMIT")
        with step-var = (gensym "STEP")
        with index-var = (make-named-variable :index)
        for (name value) in prep-phrases
        when (eq name :from-end)
          do (setf from-end-ref (gensym "FROM-END"))
          and collect `(,from-end-ref ,value) into bindings
        else when (eq name :start)
          do (setf start-ref (gensym "START"))
          and collect `(,start-ref ,value fixnum) into bindings
        else when (eq name :end)
          do (setf end-ref (gensym "END"))
          and collect `(,end-ref ,value fixnum) into bindings
        else
          do (setf seq-ref (gensym "SEQ"))
          and collect `(,seq-ref ,value sequence) into bindings
        finally (return `(((,variable nil ,data-type)
                           (,limit-var 0 fixnum)
                           (,it-var 0 fixnum)
                           (,step-var 0 fixnum)
                           ,@(when index-var
                               `((,index-var 0 fixnum)))
                           ,@bindings)
                          ((let ((end (or ,end-ref (length ,seq-ref))))
                             (setq ,it-var (if ,from-end-ref
                                               (1- end)
                                               ,start-ref)
                                   ,limit-var (if ,from-end-ref
                                                  (1- ,start-ref)
                                                  end)
                                   ,step-var (if ,from-end-ref -1 1))))
                          (= ,it-var ,limit-var)
                          ()
                          ()
                          (,variable (elt ,seq-ref ,it-var)
                           ,@(when index-var
                               `(,index-var ,it-var))
                           ,it-var (+ ,it-var ,step-var))))))
  
(add-loop-path '(:element :elements)
               'loop-elements-iteration-path
               :preposition-groups '((:of :in) (:start) (:end) (:from-end))
               :inclusive-permitted nil)
 
