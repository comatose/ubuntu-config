(add-to-list 'load-path "~/.emacs.d/plugins/emacs-color-theme-solarized")
(add-to-list 'load-path "~/.emacs.d/plugins")
(require 'color-theme-solarized)
(when  window-system
    (color-theme-solarized-dark))

(add-to-list 'completion-ignored-extensions ".hi")
(load "~/.emacs.d/plugins/haskell-mode/haskell-site-file")

(autoload 'ghc-init "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init) (flymake-mode)))

(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)

(add-hook 'haskell-mode-hook 'imenu-add-menubar-index)
(add-hook 'haskell-mode-hook 'turn-on-haskell-decl-scan)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-doc)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(haskell-mode-hook (quote (turn-on-haskell-indentation turn-on-eldoc-mode capitalized-words-mode turn-on-haskell-doc-mode turn-on-haskell-decl-scan imenu-add-menubar-index))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

(require 'xcscope)

(set-cursor-color "white")

(add-to-list 'load-path
              "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(setq yas/trigger-key "<C-tab>") ;; make sure this is before yas/initialize
(yas/global-mode 1)
(yas/load-directory "~/.emacs.d/snippets")

(custom-set-variables
'(default-input-method "korean-hangul"))

(setq kill-whole-line t)

(load-file "~/.emacs.d/init.el")

(define-key ctl-x-map "\C-q" 'view-mode)

(define-key view-mode-map (kbd "C-@") 'View-scroll-page-backward)
(define-key view-mode-map (kbd "RET") nil)
(define-key view-mode-map (kbd "j") 'next-line)
(define-key view-mode-map (kbd "k") 'previous-line)
(define-key view-mode-map (kbd "C-k") 'View-scroll-line-backward)

(global-set-key (kbd "C-x C-b") 'electric-buffer-list)
(global-set-key (kbd "M-<delete>") 'delete-window)
(define-key ctl-x-map (kbd "<right>") 'split-window-horizontally)
(define-key ctl-x-map (kbd "<down>") 'split-window-vertically)
(define-key ctl-x-map (kbd "C-<delete>") 'delete-other-window)

;; ========== Switch to view-mode Aggressively ==========
(defadvice find-file
  (after switch-to-view-mode (file &optional wild) activate)
  (view-mode 1))

(defadvice find-file-other-window
  (after switch-to-view-mode (file &optional wild) activate)
  (view-mode 1))

(defadvice find-file-other-frame
  (after switch-to-view-mode (file &optional wild) activate)
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

;; ========== Window Management  ==========


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


