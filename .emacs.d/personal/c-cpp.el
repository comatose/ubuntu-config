(prelude-require-packages '(
                            cmake-mode
                            google-c-style
                            clang-format
                            ))

(when (file-exists-p "~/src/rtags/build/src")
  (load-file "~/src/rtags/build/src/rtags.el")
  (load-file "~/src/rtags/build/src/company-rtags.el")
  (load-file "~/src/rtags/build/src/flycheck-rtags.el")
  (load-file "~/src/rtags/build/src/helm-rtags.el")
  )

;; C++11 keywords
(font-lock-add-keywords 'c-common-mode
                        '(("nullptr" . font-lock-keyword-face)))

(global-company-mode)
(rtags-enable-standard-keybindings c-mode-base-map "C-x r ")
(setq rtags-tramp-enabled t)

(defun comatose/c-mode-cedet-hook ()
  (google-set-c-style)

  (c-toggle-hungry-state 1)
  (subword-mode 1)
  (global-cwarn-mode 1)

  (define-key c-mode-base-map "\C-j" 'c-context-line-break)
  (flyspell-mode -1)

  (setq gdb-many-windows t)
  (setq gdb-show-threads-by-default t)

  (setq flycheck-clang-language-standard "c++1z")

  (rtags-start-process-unless-running)
  (setq rtags-autostart-diagnostics t)
  (rtags-diagnostics)
  (setq rtags-completions-enabled t)
  (push 'company-rtags company-backends)
  (setq rtags-display-result-backend 'helm)

  (require 'flycheck-rtags)
  (flycheck-select-checker 'rtags)
  (setq-local flycheck-highlighting-mode nil) ;; RTags creates more accurate overlays.
  (setq-local flycheck-check-syntax-automatically nil))

(add-hook 'prelude-c-mode-common-hook 'comatose/c-mode-cedet-hook 1)
