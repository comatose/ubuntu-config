(global-unset-key (kbd "C-x p"))

(mapc
 (lambda (x) (when (not (require x nil t)) (package-install x)))
 '(
   python
   flymake-python-pyflakes
   ))

(defun load-ropemacs ()
  "Load pymacs and ropemacs"
  (interactive)
  (require 'pymacs)
  (pymacs-load "ropemacs" "rope-")
  ;; Automatically save project python buffers before refactorings
  (setq ropemacs-confirm-saving 'nil)
  )

;; (global-set-key "\C-xpl" 'load-ropemacs)
(add-hook 'python-mode-hook
          '(lambda ()
             (load-ropemacs)
             (ropemacs-mode t)
             (ac-ropemacs-initialize)
             (add-to-list 'ac-sources 'ac-source-ropemacs)
             ))


(disable-theme 'zenburn)
(load-theme 'solarized-dark t)

(setq prelude-whitespace nil)
;; (whitespace-mode -1)

(setq prelude-flyspell nil)
;; (flyspell-mode -1)

(add-hook
 'haskell-mode-hook
 '(lambda ()
    (imenu-add-menubar-index)
    ;; (turn-on-font-lock)
    ;; (turn-off-haskell-doc-mode)
    (setq haskell-doc-show-global-types t)

    (turn-on-haskell-indentation)
    (capitalized-words-mode)

    (turn-on-haskell-decl-scan)
    (define-key haskell-mode-map (kbd "C-M-p") 'haskell-ds-backward-decl)
    (define-key haskell-mode-map (kbd "C-M-n") 'haskell-ds-forward-decl)

    (speedbar-add-supported-extension ".hs")

    (define-key haskell-mode-map (kbd "C-c C-h") 'haskell-hoogle)
    (define-key haskell-mode-map (kbd "C-c C-g") 'haskell-hayoo)

    ;; (setq haskell-hoogle-command "hoogle-info")

    (setq haskell-stylish-on-save t)
    ;; (setq haskell-tags-on-save t)

    (autoload 'ghc-init "ghc" nil t)
    (ghc-init)
    (flymake-mode)
    ;; ;; resolve confliction with ghc-save-buffer
    ;; (defadvice ghc-save-buffer
    ;; 	 (before stylish-and-hasktag activate)
    ;; 	 (haskell-mode-save-buffer)
    ;; 	 )
    )
 t)

(add-to-list 'completion-ignored-extensions ".hi")

(setq compilation-scroll-output t)
(setq mode-compile-always-save-buffer-p t)

;; cd /usr/src; sudo apt-get source emacs24
(setq find-function-C-source-directory "/usr/src/emacs-snapshot-20120919/src")

(setq kill-whole-line t)

(scroll-bar-mode -1)			; no scroll bars
(global-linum-mode 1)			; add line numbers on the left

(global-set-key (kbd "C-x C-z") 'magit-status)

;; Hangul bey binding
(global-set-key (kbd "<Hangul>") 'toggle-input-method)
(setq default-input-method "korean-hangul")

(setq scroll-conservatively 5)

(defun backward-same-syntax (&optional arg)
  (interactive "p")
  (forward-same-syntax (- (or arg 1))))

(defun kill-syntax (&optional arg) 
  "Kill ARG sets of syntax characters after point."
  (interactive "p")
  (let ((opoint (point)))
    (forward-same-syntax arg)
    (kill-region opoint (point))))

(defadvice forward-word (around forward-word-syntax
                                (&optional arg))
  (forward-same-syntax arg))
(ad-activate 'forward-word)

(defadvice backward-word (around backward-word-syntax
                                 (&optional arg))
  (backward-same-syntax arg))
(ad-activate 'backward-word)

(defadvice kill-word (around kill-word-syntax
                             (&optional arg))
  (kill-syntax arg))
(ad-activate 'kill-word)

;; (global-set-key (kbd "M-f") 'forward-same-syntax)
;; (global-set-key (kbd "M-b") 'backward-same-syntax)
;; (global-set-key (kbd "M-d") 'kill-syntax)

;; ========== Place Backup Files in Specific Directory ==========
(setq make-backup-files t)
(setq version-control t)
(setq backup-directory-alist (quote ((".*" . "/tmp/emacs_backups/"))))
(setq delete-old-versions t)

;; When saving files, set execute permission if #! is in first line.
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

;; http://www.masteringemacs.org/articles/2011/01/14/effective-editing-movement/
(require 'etags)
(defun ido-find-tag ()
  "Find a tag using ido"
  (interactive)
  (tags-completion-table)
  (let (tag-names)
    (mapc (lambda (x)
	    (unless (integerp x)
	      (push (prin1-to-string x t) tag-names)))
	  tags-completion-table)
    (find-tag (ido-completing-read "Tag: " tag-names))))

(defun ido-find-file-in-tag-files ()
  (interactive)
  (save-excursion
    (let ((enable-recursive-minibuffers t))
      (visit-tags-table-buffer))
    (find-file
     (expand-file-name
      (ido-completing-read
       "Project file: " (tags-table-files) nil t)))))

(global-set-key [remap find-tag] 'ido-find-tag)
(global-set-key (kbd "C-.") 'ido-find-file-in-tag-files)

;; SMART SYMBOL
(defvar smart-use-extended-syntax nil
  "If t the smart symbol functionality will consider extended
syntax in finding matches, if such matches exist.")

(defvar smart-last-symbol-name ""
  "Contains the current symbol name.

This is only refreshed when `last-command' does not contain
either `smart-symbol-go-forward' or `smart-symbol-go-backward'")

(make-local-variable 'smart-use-extended-syntax)

(defvar smart-symbol-old-pt nil
  "Contains the location of the old point")

(defun smart-symbol-goto (name direction)
  "Jumps to the next NAME in DIRECTION in the current buffer.

DIRECTION must be either `forward' or `backward'; no other option
is valid."

  ;; if `last-command' did not contain
  ;; `smart-symbol-go-forward/backward' then we assume it's a
  ;; brand-new command and we re-set the search term.
  (unless (memq last-command '(smart-symbol-go-forward
                               smart-symbol-go-backward))
    (setq smart-last-symbol-name name))
  (setq smart-symbol-old-pt (point))
  (message (format "%s scan for symbol \"%s\""
                   (capitalize (symbol-name direction))
                   smart-last-symbol-name))
  (unless (catch 'done
            (while (funcall (cond
                             ((eq direction 'forward) ; forward
                              'search-forward)
                             ((eq direction 'backward) ; backward
                              'search-backward)
                             (t (error "Invalid direction"))) ; all others
                            smart-last-symbol-name nil t)
              (unless (memq (syntax-ppss-context
                             (syntax-ppss (point))) '(string comment))
                (throw 'done t))))
    (goto-char smart-symbol-old-pt)))

(defun smart-symbol-go-forward ()
  "Jumps forward to the next symbol at point"
  (interactive)
  (smart-symbol-goto (smart-symbol-at-pt 'end) 'forward))

(defun smart-symbol-go-backward ()
  "Jumps backward to the previous symbol at point"
  (interactive)
  (smart-symbol-goto (smart-symbol-at-pt 'beginning) 'backward))

(defun smart-symbol-at-pt (&optional dir)
  "Returns the symbol at point and moves point to DIR (either `beginning' or `end') of the symbol.

If `smart-use-extended-syntax' is t then that symbol is returned
instead."
  (with-syntax-table (make-syntax-table)
    (if smart-use-extended-syntax
        (modify-syntax-entry ?. "w"))
    (modify-syntax-entry ?_ "w")
    (modify-syntax-entry ?- "w")
    ;; grab the word and return it
    (let ((word (thing-at-point 'word))
          (bounds (bounds-of-thing-at-point 'word)))
      (if word
          (progn
            (cond
             ((eq dir 'beginning) (goto-char (car bounds)))
             ((eq dir 'end) (goto-char (cdr bounds)))
             (t (error "Invalid direction")))
            word)
        (error "No symbol found")))))

(global-set-key (kbd "M-n") 'smart-symbol-go-forward)
(global-set-key (kbd "M-p") 'smart-symbol-go-backward)

;; MARK
(defun push-mark-no-activate ()
  "Pushes `point' to `mark-ring' and does not activate the region
Equivalent to \\[set-mark-command] when \\[transient-mark-mode] is disabled"
  (interactive)
  (push-mark (point) t nil)
  (message "Pushed mark to ring"))
(global-set-key (kbd "C-`") 'push-mark-no-activate)

(defun jump-to-mark ()
  "Jumps to the local mark, respecting the `mark-ring' order.
This is the same as using \\[set-mark-command] with the prefix argument."
  (interactive)
  (set-mark-command 1))
(global-set-key (kbd "M-`") 'jump-to-mark)

;; ==================================================================
(set-fontset-font "fontset-default" '(#x1100 . #xffdc)  '("NanumGothicCoding" . "unicode-bmp"))
(set-fontset-font "fontset-default" '(#xe0bc . #xf66e)  '("NanumGothicCoding" . "unicode-bmp"))
(set-fontset-font "fontset-default" 'kana '("Meiryo" . "unicode-bmp"))
(set-fontset-font "fontset-default" 'han '("Microsoft YaHei" . "unicode-bmp"))
