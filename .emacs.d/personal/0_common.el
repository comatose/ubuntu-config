(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

(prelude-require-packages '(
                            color-theme-sanityinc-solarized
                            yasnippet
                            auto-complete
                            iedit
                            framemove
                            switch-window
                            company
                            ))

(add-hook 'after-init-hook
          (lambda ()
            ""

            (load-theme 'sanityinc-solarized-dark)

            (yas-global-mode 1)

            (require 'auto-complete)
            (require 'auto-complete-config)
            (ac-config-default)
            (setq ac-auto-start nil)
            (define-key ac-mode-map (kbd "M-<return>") 'auto-complete)

            (require 'iedit)

            (windmove-default-keybindings)
            (setq framemove-hook-into-windmove t)
            (setq switch-window-shortcut-style 'qwerty)

            (key-chord-define-global "jw" 'switch-window)
            (key-chord-define-global "dw" 'delete-other-window)

            ;;  Displaying compilation error messages in the echo area
            (setq help-at-pt-display-when-idle t)
            (setq help-at-pt-timer-delay 0.1)
            (help-at-pt-set-timer)

            (require 'company)
            (setq company-idle-delay nil)
            (global-company-mode t)
            (global-set-key (kbd "C-<return>") 'company-complete-common)
            )
          t)

;; cd /usr/src; sudo apt-get source emacs24
(setq find-function-C-source-directory "/usr/src/emacs24-24.2+1/src")

(set-frame-font "NanumGothicCoding-12")

(scroll-bar-mode -1)                    ;; no scroll bars
(global-linum-mode 1)                   ;; add line numbers on the left

(set-fringe-style nil)

(setq kill-whole-line t)

(global-unset-key (kbd "C-x p"))        ;; disable proced key binding

;; Hangul key binding
(global-set-key (kbd "<Hangul>") 'toggle-input-method)
(setq default-input-method "korean-hangul")

;; ========== Place Backup Files in Specific Directory ==========
(setq make-backup-files t)
(setq version-control t)
(setq backup-directory-alist (quote ((".*" . "/tmp/emacs_backups/"))))
(setq delete-old-versions t)

;; When saving files, set execute permission if #! is in first line.
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

;; (setq prelude-whitespace nil)   ;; (whitespace-mode -1)
(setq prelude-flyspell nil)     ;; (flyspell-mode -1)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; reserved for future uses

;; (setq scroll-conservatively 100000)

;; (defun backward-same-syntax (&optional arg)
;;   (interactive "p")
;;   (forward-same-syntax (- (or arg 1))))

;; (defun kill-syntax (&optional arg)
;;   "Kill ARG sets of syntax characters after point."
;;   (interactive "p")
;;   (let ((opoint (point)))
;;     (forward-same-syntax arg)
;;     (kill-region opoint (point))))

;; (defadvice forward-word (around forward-word-syntax
;;                                 (&optional arg))
;;   (forward-same-syntax arg))
;; (ad-activate 'forward-word)

;; (defadvice backward-word (around backward-word-syntax
;;                                  (&optional arg))
;;   (backward-same-syntax arg))
;; (ad-activate 'backward-word)

;; (defadvice kill-word (around kill-word-syntax
;;                              (&optional arg))
;;   (kill-syntax arg))
;; (ad-activate 'kill-word)

;; (global-set-key (kbd "M-f") 'forward-same-syntax)
;; (global-set-key (kbd "M-b") 'backward-same-syntax)
;; (global-set-key (kbd "M-d") 'kill-syntax)

;; (setq compilation-scroll-output t)
;; (setq mode-compile-always-save-buffer-p t)
