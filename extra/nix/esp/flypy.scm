(require "generic.scm")
(require "py.scm")

(define flypy-initials2 '(("zh" . "v") ("ch" . "i") ("sh" . "u")))
(define flypy-initials1
  '(
    ("b" . "b") ("p" . "p") ("m" . "m") ("f" . "f")
    ("d" . "d") ("t" . "t") ("n" . "n") ("l" . "l")
    ("g" . "g") ("k" . "k") ("h" . "h")
    ("j" . "j") ("q" . "q") ("x" . "x")
    ("r" . "r") ("z" . "z") ("c" . "c") ("s" . "s")
    ("y" . "y") ("w" . "w")
  ))

(define flypy-finals
  '(
    ("iang" . "l") ("iong" . "s") ("uang" . "l") ("uai" . "k")
    ("ian" . "m") ("iao" . "n") ("ing" . "k") ("uan" . "r")
    ("ue" . "t") ("ve" . "t")
    ("ang" . "h") ("eng" . "g") ("ong" . "s")
    ("un" . "y") ("uo" . "o") ("ui" . "v")
    ("ua" . "x") ("iu" . "q") ("in" . "b") ("ie" . "p") ("ia" . "x")
    ("an" . "j") ("en" . "f") ("ai" . "d") ("ei" . "w")
    ("ao" . "c") ("ou" . "z") ("er" . "r")
    ("a" . "a") ("o" . "o") ("e" . "e") ("i" . "i") ("u" . "u") ("v" . "v")
  ))

(define (flypy-final-code s)
  (let ((e (assoc s flypy-finals)))
    (if e (cdr e) #f)))

(define (flypy-code s)
  (let* ((n (string-length s))
         (d2 (and (>= n 3) (assoc (substring s 0 2) flypy-initials2)))
         (d1 (and (>= n 2) (assoc (substring s 0 1) flypy-initials1))))
    (cond
      (d2
       (let ((f (flypy-final-code (substring s 2 n))))
         (if f (string-append (cdr d2) f) s)))
      (d1
       (let ((f (flypy-final-code (substring s 1 n))))
         (if f (string-append (cdr d1) f) s)))
      (else
       (let ((f (flypy-final-code s)))
         (if f (string-append (substring s 0 1) f) s))))))

(define (flypy-keys code)
  (map (lambda (c) (list->string (list c))) (string->list code)))

(define (flypy-rekey seqs)
  (map
    (lambda (seq) (flypy-keys (flypy-code (apply string-append seq))))
    seqs))

(define flypy-rule
  (append
    (map
      (lambda (entry) (list (flypy-rekey (car entry)) (cadr entry)))
      py-rule)
    (if (symbol-bound? 'flypy-words) flypy-words '())))

(define flypy-init-handler
  (lambda (id im arg)
    (generic-context-new id im flypy-rule #f)))

(if (not (memq 'py-flypy enabled-im-list))
    (set! enabled-im-list (append enabled-im-list '(py-flypy))))

(generic-register-im
  'py-flypy
  "zh_CN"
  "UTF-8"
  (N_ "Xiaohe double pinyin")
  (N_ "Double pinyin (Xiaohe) for Simplified Chinese")
  flypy-init-handler)

(custom-set-value! 'generic-on-key '("<Control>\\" "<Control> " "<Shift> "))
(custom-set-value! 'generic-off-key '("<Control>\\" "<Control> " "<Shift> "))
