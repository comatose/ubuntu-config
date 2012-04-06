(add-to-list 'load-path "~/.emacs.d/plugins")

;; ========== emacs-kicker  ==========
(load-file "~/.emacs.d/init.el")

;; ========== color-theme-solarized  ==========
(require 'color-theme-solarized)
(if window-system
  (color-theme-solarized-dark) ;; don't load solarized-themes to make the background transparent, unless using window-system
  (require 'xclip)) ;; using x clip board system when terminal-mode.
;;  (load-file "~/.emacs.d/plugins/xclip.el")) ;; using x clip board system.

;; ========== haskell-mode  ==========
(require 'haskell-mode)

(add-to-list 'completion-ignored-extensions ".hi")

(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)

;; ========== view-mode  ==========
(define-key ctl-x-map "\C-q" 'view-mode)

(define-key view-mode-map (kbd "M-<SPC>") 'View-scroll-page-backward)
(define-key view-mode-map (kbd "RET") nil)
(define-key view-mode-map (kbd "j") 'next-line)
(define-key view-mode-map (kbd "k") 'previous-line)
(define-key view-mode-map (kbd "C-k") 'View-scroll-line-backward)

;; Switch to view-mode Aggressively
(defadvice find-file
  (after switch-to-view-mode (file &optional wild) activate)
  (view-mode 1))

(defadvice find-file-other-window
  (after switch-to-view-mode (file &optional wild) activate)
  (view-mode 1))

(defadvice find-file-other-frame
  (after switch-to-view-mode (file &optional wild) activate)
  (view-mode 1))

(defadvice ido-find-file-read-only
  (after switch-to-view-mode activate)
  (view-mode 1))

(defadvice ido-find-file-read-only-other-window
  (after switch-to-view-mode activate)
  (view-mode 1))

(defadvice ido-find-file-read-only-other-frame
  (after switch-to-view-mode activate)
  (view-mode 1))

(defadvice ido-find-file 
  (after switch-to-view-mode activate)
  (view-mode 1))

(defadvice ido-find-file-other-window
  (after switch-to-view-mode activate)
  (view-mode 1))

(defadvice ido-find-file-other-frame
  (after switch-to-view-mode activate)
  (view-mode 1))

(defadvice save-buffer
  (after switch-to-view-mode activate)
  (view-mode 1))

;; ========== etc.  ==========
(require 'auto-complete)
(global-auto-complete-mode 1)

(require 'xcscope)

(require 'yasnippet)
(setq yas/trigger-key "<C-tab>") ;; make sure this is before yas/initialize
(yas/global-mode 1)
;; (yas/load-directory "~/.emacs.d/snippets")

(setq find-function-C-source-directory "~/src/emacs23-23.3+1/src")

(custom-set-variables
'(default-input-method "korean-hangul"))

(setq kill-whole-line t)

(global-set-key (kbd "C-x C-b") 'electric-buffer-list)
(global-set-key (kbd "M-<delete>") 'delete-window)
(define-key ctl-x-map (kbd "<right>") 'split-window-horizontally)
(define-key ctl-x-map (kbd "<down>") 'split-window-vertically)
(define-key ctl-x-map (kbd "C-<delete>") 'delete-other-window)

;; ========== http://dotfiles.org/~rretzbach/.emacs ==========
;; ========== Line by line scrolling ==========
;; This makes the buffer scroll by only a single line when the up or
;; down cursor keys push the cursor (tool-bar-mode) outside the
;; buffer. The standard emacs behaviour is to reposition the cursor in
;; the center of the screen, but this can make the scrolling confusing

(setq scroll-step 1)
(setq scroll-conservatively 5)

;; ========== Place Backup Files in Specific Directory ==========
;; Enable backup files.
(setq make-backup-files t)

;; Enable versioning with default values (keep five last versions, I think!)
(setq version-control t)

;; Save all backup file in this directory.
(setq backup-directory-alist (quote ((".*" . "~/.emacs_backups/"))))

;; ========== from http://dotfiles.org/~rretzbach/.emacs ==========
;; set default mode
(setq default-major-mode 'text-mode)
(setq initial-major-mode 'text-mode)

;; When saving files, set execute permission if #! is in first line.
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

;; show matching parens
(require 'paren) (show-paren-mode t)

;; ========== from http://dotfiles.org/~lwu/.emacs ==========
; Meta [ and ] enlarge and shrink the current window
(global-set-key (kbd "M-]") 'enlarge-window)


