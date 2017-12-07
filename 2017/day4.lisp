(defun run ()
  (list-length (countit (get-file "input.txt"))))

(defun countit (input)
  (remove nil (transform input)))

(defun transform (input)
  (let (apan (mapcar 'str-split input)
  (mapcar 'isok apan))))

(defun isok (strings)
  (eq (remove-duplicates strings :test #'equal) strings))

;; Utils
;; https://rosettacode.org/wiki/Tokenize_a_string#Common_Lisp
(defun str-split (string)
  (loop for start = 0 then (1+ finish)
        for finish = (position #\  string :start start)
        collecting (subseq string start finish)
        until (null finish)))

(defun get-file (filename)
  (with-open-file (stream filename)
                  (loop for line = (read-line stream nil)
                        while line
                        collect line)))
