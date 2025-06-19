(cl:in-package #:loop-iteration-paths/test)

(define-test bytes-01
  (is equal
      '(0 1 2 3 4 5 6)
      (with-input-from-bytes (stream #(0 1 2 3 4 5 6))
        (loop for i being the bytes in stream
              collect i))))
(define-test characters-01
  (is equal
      '(#\a #\b #\c #\d #\e #\f #\g)
      (with-input-from-string (stream "abcdefg")
        (loop for i being the characters in stream
              collect i))))

(define-test lines-01
  (is equal
      '("ab" "cde" "fg")
      (with-input-from-string (stream "ab
cde
fg")
        (loop for i being the lines in stream
              collect i))))

(define-test lines-02
  (is equal
      '("ab" nil "cde" nil "fg" t)
      (with-input-from-string (stream "ab
cde
fg")
        (loop for i being the lines in stream using (missing-newline-p l)
              collect i
              collect l))))

(define-test objects-01
  (is equal
      '(1 t (2 3 #\a))
      (with-standard-io-syntax
        (with-input-from-string (stream "1 t (2 3 #\\a)")
          (loop for i being the objects in stream
                collect i)))))
