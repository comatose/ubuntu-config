(add-to-list 'load-path "~/.emacs.d/plugins/emacs-color-theme-solarized")
(add-to-list 'load-path "~/.emacs.d/plugins")
(require 'color-theme-solarized)
(color-theme-solarized-light)

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

(define-key ctl-x-map "\C-q" 'view-mode)
(defadvice find-file
  (after find-file-switch-to-view-file (file &optional wild) activate)
  (view-mode))

(add-to-list 'load-path
              "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(yas/global-mode 1)

(custom-set-variables
'(default-input-method "korean-hangul"))

(load-file "~/.emacs.d/init.el")

(defadvice ido-find-file 
  (after switch-to-view-mode activate)
  (view-mode))

(defadvice ido-find-file-other-window
  (after switch-to-view-mode activate)
  (view-mode))

(defadvice ido-find-file-other-frame
  (after switch-to-view-mode activate)
  (view-mode))
