(prelude-require-packages '(
                            ;; ecb
                            ;; cmake-mode
                            ;; cmake-project
                            ;; company-cmake
                            rtags
                            flycheck-rtags
                            helm-rtags
                            google-c-style
                            ))

;; C++11 keywords
(font-lock-add-keywords 'c-common-mode
                        '(("nullptr" . font-lock-keyword-face)))

(rtags-enable-standard-keybindings c-mode-base-map "C-x r")
(setq rtags-display-result-backend 'helm)
(setq rtags-autostart-diagnostics t)
(setq rtags-completions-enabled t)
(push 'company-rtags company-backends)
(global-company-mode)

(defun my-c-mode-common-hook ()
  (google-set-c-style)
  (google-make-newline-indent)

  (local-set-key "\C-xt" 'ff-find-related-file)

  (c-toggle-hungry-state 1)
  (subword-mode 1)
  (global-cwarn-mode 1)

  (define-key c-mode-base-map "\C-j" 'c-context-line-break)
  (flyspell-mode -1)

  (setq gdb-many-windows t)
  (setq gdb-show-threads-by-default t)

  ;; (setq flycheck-clang-language-standard "c++1z")

  (rtags-start-process-unless-running)
  (rtags-diagnostics)

  (require 'flycheck-rtags)
  (flycheck-select-checker 'rtags)
  (setq-local flycheck-highlighting-mode nil) ;; RTags creates more accurate overlays.
  (setq-local flycheck-check-syntax-automatically nil)
  )

(add-hook 'prelude-c-mode-common-hook 'my-c-mode-common-hook t) ;; append to override the setting
