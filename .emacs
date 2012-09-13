;; sudo apt-get install emacs emacs24-el
(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/plugins/")

;; el-get
(load "~/.emacs.d/rc/emacs-rc-el-get.el")

;; install required packages
(add-hook 'after-init-hook '(lambda () (load-file "~/.emacs.loadpackages")))

;; ================ CEDET ================
(load "~/.emacs.d/rc/emacs-rc-cedet.el")

;; ========== view-mode  ==========
(define-key ctl-x-map (kbd "C-q") 'view-mode)

(add-hook 'view-mode-hook
	  '(lambda ()
	     (define-key view-mode-map (kbd "RET") nil)
	     (define-key view-mode-map (kbd "o") nil)
	     (define-key view-mode-map (kbd "g") nil)
	     (define-key view-mode-map (kbd "<") nil)
	     (define-key view-mode-map (kbd ">") nil)
	     (define-key view-mode-map (kbd "j") (lambda () (interactive) (next-line 10)))
	     (define-key view-mode-map (kbd "k") (lambda () (interactive) (previous-line 10)))
	     ))

;; ;; Switch to view-mode Aggressively
;; (defadvice find-file
;;   (after switch-to-view-mode activate)
;; ;;  (after switch-to-view-mode (file &optional wild) activate)
;;   (view-mode 1))
;; (defadvice find-file-other-window
;;   (after switch-to-view-mode activate)
;; ;;  (after switch-to-view-mode (file &optional wild) activate)
;;   (view-mode 1))
;; (defadvice find-file-other-frame
;;   (after switch-to-view-mode activate)
;; ;;  (after switch-to-view-mode (file &optional wild) activate)
;;   (view-mode 1))
;; (defadvice ido-file-internal
;;   (after switch-to-view-mode activate)
;;   (view-mode 1))

;; ========== etc.  ==========
(setq enable-recursive-minibuffers t)

(define-key ctl-x-map (kbd "c") 'delete-frame)

(define-key global-map (kbd "RET") 'newline-and-indent)

(add-to-list 'completion-ignored-extensions ".hi")

;; cd /usr/src; sudo apt-get source emacs24
(setq find-function-C-source-directory "/usr/src/emacs24-24.1+1/src")

(setq kill-whole-line t)

(fset 'yes-or-no-p 'y-or-n-p)

;; Hangul bey binding
(global-set-key (kbd "<Hangul>") 'toggle-input-method)
(setq default-input-method "korean-hangul")

(global-set-key (kbd "M-<delete>") 'delete-window)
(global-set-key (kbd "C-w") 'backward-kill-word)

(define-key ctl-x-map (kbd "C-b") 'electric-buffer-list)
(define-key ctl-x-map (kbd "l") 'split-window-horizontally)
(define-key ctl-x-map (kbd "j") 'split-window-vertically)
(define-key ctl-x-map (kbd "C-<delete>") 'delete-other-window)
(define-key ctl-x-map (kbd "C-k") 'kill-region)

;; on to the visual settings
(setq inhibit-splash-screen t)		; no splash screen, thanks
(line-number-mode 1)			; have line numbers and
(column-number-mode 1)			; column numbers in the mode line

(tool-bar-mode -1)			; no tool bar with icons
(scroll-bar-mode -1)			; no scroll bars

(global-hl-line-mode)			; highlight current line
(global-linum-mode 1)			; add line numbers on the left

;; Use the clipboard, pretty please, so that copy/paste "works"
;; (setq mouse-drag-copy-region nil)  ; stops selection with a mouse being immediately injected to the kill ring
;; ;; (setq x-select-enable-primary nil)  ; stops killing/yanking interacting with primary X11 selection
;; (setq x-select-enable-clipboard t)

;; Navigate windows with M-<arrows>
(windmove-default-keybindings 'meta)
(setq windmove-wrap-around t)

; winner-mode provides C-<left> to get back to previous window layout
(winner-mode 1)

;; whenever an external process changes a file underneath emacs, and there
;; was no unsaved changes in the corresponding buffer, just revert its
;; content to reflect what's on-disk.
(global-auto-revert-mode 1)

;; M-x shell is a nice shell interface to use, let's make it colorful.  If
;; you need a terminal emulator rather than just a shell, consider M-x term
;; instead.
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; avoid compiz manager rendering bugs
(add-to-list 'default-frame-alist '(alpha . 100))
;; ========== http://dotfiles.org/~rretzbach/.emacs ==========
;; ========== Line by line scrolling ==========
;; This makes the buffer scroll by only a single line when the up or
;; down cursor keys push the cursor (tool-bar-mode) outside the
;; buffer. The standard emacs behaviour is to reposition the cursor in
;; the center of the screen, but this can make the scrolling confusing

(setq scroll-step 0)
(setq scroll-conservatively 5)
(setq scroll-preserve-screen-position t)

;; ========== Place Backup Files in Specific Directory ==========
;; Enable backup files.
(setq make-backup-files t)

;; Enable versioning with default values (keep five last versions, I think!)
(setq version-control t)

;; Save all backup file in this directory.
(setq backup-directory-alist (quote ((".*" . "/tmp/emacs_backups/"))))

;; ========== from http://dotfiles.org/~rretzbach/.emacs ==========
;; set default mode
(setq default-major-mode 'text-mode)
(setq initial-major-mode 'text-mode)

;; When saving files, set execute permission if #! is in first line.
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

;; ========== from http://dotfiles.org/~lwu/.emacs ==========
; Meta [ and ] enlarge and shrink the current window
(global-set-key (kbd "M-]") 'enlarge-window)

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
(set-fontset-font "fontset-default" '(#x1100 . #xffdc)  '("NANumGothicCoding" . "unicode-bmp")) ;;; 유니코드 한글영역...NanumGothicCoding에다가 원하는폰트를 적는다
(set-fontset-font "fontset-default" '(#xe0bc . #xf66e)  '("NanumGothicCoding" . "unicode-bmp")) ;;;유니코드 사용자 영역
(set-fontset-font "fontset-default" 'kana '("Meiryo" . "unicode-bmp"))
(set-fontset-font "fontset-default" 'han '("Microsoft YaHei" . "unicode-bmp"))

;; ==================================================================
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(compilation-auto-jump-to-first-error t)
 '(compilation-skip-threshold 2)
 '(ede-project-directories (quote ("/home/comatose/workspace/test01" "/home/comatose/src/SAVLSim/arraysim")))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "NanumGothicCoding" :foundry "unknown" :slant normal :weight normal :height 113 :width normal)))))
