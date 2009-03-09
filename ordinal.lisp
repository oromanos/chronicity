(cl:in-package #:chronicity)

;;; Enable cl-interpol reader

(cl-interpol:enable-interpol-syntax)

(defclass ordinal (tag)
  ())

(defmethod scan-tokens ((tag (eql 'ordinal)) tokens)
  (dolist (token tokens tokens)
    (awhen (scan-for-ordinals token) (tag it token))
    (awhen (scan-for-ordinal-days token) (tag it token))))

(defun scan-for-ordinals (token)
  (when (cl-ppcre:scan #?r"^(\d*)(st|nd|rd|th)$" (token-word token))
    (create-tag 'ordinal (parse-integer (token-word token)))))

(defclass ordinal-day (tag)
  ())

(defun scan-for-ordinal-days (token)
  (when (and (cl-ppcre:scan #?r"^(\d*)(st|nd|rd|th)$" (token-word token))
             (<= (parse-integer (token-word token)) 31))
    (create-tag 'ordinal-day (parse-integer (token-word token)))))

;;; Disable cl-interpol reader

(cl-interpol:disable-interpol-syntax)
