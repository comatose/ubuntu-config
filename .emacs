;; sudo apt-get install emacs emacs-goodies-el emacs23-el
(add-to-list 'load-path "~/.emacs.d/plugins")

;; ========== emacs-kicker  ==========
(load-file "~/.emacs.d/init.el")

;; ========== color-theme-solarized  ==========
(require 'color-theme-solarized)

;; don't load solarized-themes to make the background transparent, unless using window-system
(when window-system
  (color-theme-solarized-dark))

;; ========== haskell-mode  ==========
;; (load "haskell-site-file")
(load "haskell-process")
(load "haskell-session")
(load "haskell-interactive-mode")

;; (add-to-list 'completion-ignored-extensions ".hi")

;; Add the dir for loading haskell-site-file.
(load-file "~/.emacs.d/el-get/haskell-mode/examples/init.el")

(add-hook 'haskell-mode-hook 'haskell-hook-second t)

(defun haskell-hook-second ()
  (setq haskell-process-type 'ghci)

  (turn-off-haskell-simple-indent)
  (define-key haskell-mode-map (kbd "<return>") nil)
  (define-key haskell-mode-map (kbd "C-<return>") nil)

  (turn-on-haskell-indentation)
  (turn-on-haskell-doc-mode)
  (font-lock-mode)

  (define-key haskell-mode-map (kbd "C-c C-g") 'haskell-hoogle)
  (define-key haskell-mode-map (kbd "C-c C-h") 'haskell-hayoo)
)

;; ========== view-mode  ==========
(define-key ctl-x-map (kbd "C-q") 'view-mode)

(define-key view-mode-map (kbd "M-<SPC>") 'View-scroll-page-backward)
(define-key view-mode-map (kbd "RET") nil)
(define-key view-mode-map (kbd "o") nil)
(define-key view-mode-map (kbd "g") nil)
(define-key view-mode-map (kbd "<") nil)
(define-key view-mode-map (kbd ">") nil)
(define-key view-mode-map (kbd "j") 'next-line)
(define-key view-mode-map (kbd "k") 'previous-line)
(define-key view-mode-map (kbd "C-k") 'View-scroll-line-backward)

;; Switch to view-mode Aggressively
(defadvice find-file
  (after switch-to-view-mode activate)
;;  (after switch-to-view-mode (file &optional wild) activate)
  (view-mode 1))

(defadvice find-file-other-window
  (after switch-to-view-mode activate)
;;  (after switch-to-view-mode (file &optional wild) activate)
  (view-mode 1))

(defadvice find-file-other-frame
  (after switch-to-view-mode activate)
;;  (after switch-to-view-mode (file &optional wild) activate)
  (view-mode 1))

(defadvice ido-file-internal
  (after switch-to-view-mode activate)
  (view-mode 1))

;; (defadvice ido-find-file-read-only
;;   (after switch-to-view-mode activate)
;;   (view-mode 1))

;; (defadvice ido-find-file-read-only-other-window
;;   (after switch-to-view-mode activate)
;;   (view-mode 1))

;; (defadvice ido-find-file-read-only-other-frame
;;   (after switch-to-view-mode activate)
;;   (view-mode 1))

;; (defadvice ido-find-file 
;;   (after switch-to-view-mode activate)
;;   (view-mode 1))

;; (defadvice ido-find-file-other-window
;;   (after switch-to-view-mode activate)
;;   (view-mode 1))

;; (defadvice ido-find-file-other-frame
;;   (after switch-to-view-mode activate)
;;   (view-mode 1))

;; (defadvice save-buffer
;;   (after switch-to-view-mode activate)
;;   (view-mode 1))

;; ========== etc.  ==========
(unless window-system
  (require 'xclip)) ;; using x clip board system when terminal-mode.

(require 'auto-complete)
(global-auto-complete-mode 1)

(require 'xcscope)

(require 'yasnippet)
(setq yas/trigger-key "<C-tab>") ;; make sure this is before yas/initialize
(yas/global-mode 1)
(yas/load-directory "~/.emacs.d/snippets")

(setq find-function-C-source-directory "~/src/emacs23-23.3+1/src")

(setq kill-whole-line t)

(fset 'yes-or-no-p 'y-or-n-p)

;; Hangul bey binding
(global-set-key (kbd "<Hangul>") 'toggle-input-method)
(setq default-input-method "korean-hangul")

(global-set-key (kbd "C-x C-b") 'electric-buffer-list)
(global-set-key (kbd "M-<delete>") 'delete-window)
(define-key ctl-x-map (kbd "l") 'split-window-horizontally)
(define-key ctl-x-map (kbd "j") 'split-window-vertically)
(define-key ctl-x-map (kbd "C-<delete>") 'delete-other-window)

(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)

(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)

(global-set-key (kbd "<S-up>") 'bmkp-previous-bookmark)
(global-set-key (kbd "<S-down>") 'bmkp-next-bookmark)

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

;; ==================================================================
(set-fontset-font "fontset-default" '(#x1100 . #xffdc)  '("NANumGothicCoding" . "unicode-bmp")) ;;; 유니코드 한글영역...NanumGothicCoding에다가 원하는폰트를 적는다
(set-fontset-font "fontset-default" '(#xe0bc . #xf66e)  '("NanumGothicCoding" . "unicode-bmp")) ;;;유니코드 사용자 영역
(set-fontset-font "fontset-default" 'kana '("Meiryo" . "unicode-bmp"))
(set-fontset-font "fontset-default" 'han '("Microsoft YaHei" . "unicode-bmp"))
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(bmkp-last-as-first-bookmark-file "~/.emacs.bmk")
 '(haskell-notify-p t)
 '(haskell-process-type (quote cabal-dev)))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
