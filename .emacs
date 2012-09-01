;; sudo apt-get install emacs emacs-goodies-el emacs23-el
(add-to-list 'load-path "~/.emacs.d/plugins")

;; install required packages
(add-hook 'after-init-hook '(lambda () (load-file "~/.emacs.loadpackages")))

;; ========== emacs-kicker  ==========
;; (load-file "~/.emacs.d/init.el")

;; ========== view-mode  ==========
(define-key ctl-x-map (kbd "C-q") 'view-mode)

(add-hook 'view-mode-hook (lambda ()
  (define-key view-mode-map (kbd "RET") nil)
  (define-key view-mode-map (kbd "o") nil)
  (define-key view-mode-map (kbd "g") nil)
  (define-key view-mode-map (kbd "<") nil)
  (define-key view-mode-map (kbd ">") nil)
  (define-key view-mode-map (kbd "j") (lambda () (interactive) (next-line 10)))
  (define-key view-mode-map (kbd "k") (lambda () (interactive) (previous-line 10)))))

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

;; ========== etc.  ==========
(add-to-list 'completion-ignored-extensions ".hi")

(setq find-function-C-source-directory "~/src/emacs23-23.3+1/src")

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
(define-key ctl-x-map (kbd "C-m") 'execute-extended-command)
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
(setq backup-directory-alist (quote ((".*" . "~/.emacs_backups/"))))

;; ========== from http://dotfiles.org/~rretzbach/.emacs ==========
;; set default mode
(setq default-major-mode 'text-mode)
(setq initial-major-mode 'text-mode)

;; When saving files, set execute permission if #! is in first line.
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

;; ========== from http://dotfiles.org/~lwu/.emacs ==========
; Meta [ and ] enlarge and shrink the current window
(global-set-key (kbd "M-]") 'enlarge-window)

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
 '(compilation-auto-jump-to-first-error t)
 '(compilation-skip-threshold 2)
)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
