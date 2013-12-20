(prelude-require-packages '(
                            ecb
                            ))

;; C++11 keywords
(font-lock-add-keywords 'c-common-mode
                        '(("nullptr" . font-lock-keyword-face)))

(require 'cedet)

;; select which submodes we want to activate
(add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode)
;; (add-to-list 'semantic-default-submodes 'global-cedet-m3-minor-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-highlight-func-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-local-symbol-highlight-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)
;; (add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode)

;; Activate semantic
(semantic-mode 1)

(which-function-mode 1)

(setq semanticdb-default-save-directory "~/.emacs.d/semanticdb")

(require 'semantic/ia)
(require 'semantic/bovine/gcc)

;; customisation of modes
(defun alexott/cedet-hook ()
  ;; (local-set-key (kbd "C-<return>") 'semantic-ia-complete-symbol-menu)
  ;; (local-set-key (kbd "C-c >") 'semantic-complete-analyze-inline)
  ;; (local-set-key (kbd "C-c ?") 'semantic-ia-complete-symbol)
  ;; (local-set-key (kbd "C-c =") 'semantic-decoration-include-visit)

  (local-set-key (kbd "C-c j") 'semantic-ia-fast-jump)
  (local-set-key (kbd "C-c q") 'semantic-ia-show-doc)
  (local-set-key (kbd "C-c s") 'semantic-ia-show-summary)
  (local-set-key (kbd "C-c J") 'semantic-mrub-switch-tags)
  (local-set-key (kbd "C-c p") 'semantic-analyze-proto-impl-toggle)

  (local-set-key (kbd "C-c , j") 'semantic-complete-jump-local)
  (local-set-key (kbd "C-c , J") 'semantic-complete-jump)
  (local-set-key (kbd "C-c , u") 'senator-go-to-up-reference)
  (local-set-key (kbd "C-c , p") 'senator-previous-tag)
  (local-set-key (kbd "C-c , n") 'senator-next-tag)

  ;; (local-set-key (kbd "C-c <left>") 'semantic-tag-folding-fold-block)
  ;; (local-set-key (kbd "C-c <right>") 'semantic-tag-folding-show-block)
  )

(add-hook 'c-mode-common-hook 'alexott/cedet-hook)
(add-hook 'lisp-mode-hook 'alexott/cedet-hook)
(add-hook 'scheme-mode-hook 'alexott/cedet-hook)
(add-hook 'emacs-lisp-mode-hook 'alexott/cedet-hook)
(add-hook 'erlang-mode-hook 'alexott/cedet-hook)
(add-hook 'python-mode-hook 'alexott/cedet-hook)

;; load contrib library
;; (require 'eassist)

(defun alexott/c-mode-cedet-hook ()
  (local-set-key (kbd ".") 'semantic-complete-self-insert)
  (local-set-key (kbd ">") 'semantic-complete-self-insert)

  (local-set-key (kbd "C-c , c") 'semantic-symref)
  (local-set-key (kbd "C-c , C") 'semantic-symref-symbol)

  ;; (local-set-key "\C-ct" 'eassist-switch-h-cpp)
  (local-set-key "\C-xt" 'ff-find-related-file)
  ;; (local-set-key "\C-ce" 'eassist-list-methods)
  (local-set-key "\C-c\C-r" 'semantic-symref)

  (semanticdb-enable-gnu-global-databases 'c-mode)
  (semanticdb-enable-gnu-global-databases 'c++-mode)

  (add-to-list 'ac-sources 'ac-source-gtags)
  (add-to-list 'ac-sources 'ac-source-semantic)

  (c-toggle-hungry-state 1)
  (subword-mode 1)
  (global-cwarn-mode 1)

  (define-key c-mode-base-map "\C-j" 'c-context-line-break)
  (flyspell-mode -1)

  (setq gdb-many-windows t)
  (setq gdb-show-threads-by-default t)
  )

(add-hook 'c-mode-common-hook 'alexott/c-mode-cedet-hook)

;; SRecode
(require 'srecode)
(global-srecode-minor-mode 1)

;; EDE
(global-ede-mode 1)
(ede-enable-generic-projects)

;; Setup JAVA....
;; (require 'cedet-java)

;;; minimial-cedet-config.el ends here

;; add external library path for semantic
;; (semantic-add-system-include "~/exp/include/boost_1_37" 'c++-mode)
;; (setq qt4-base-dir "/usr/include/qt4")
;; (semantic-add-system-include qt4-base-dir 'c++-mode)
;; (add-to-list 'auto-mode-alist (cons qt4-base-dir 'c++-mode))
;; (add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt4-base-dir "/Qt/qconfig.h"))
;; (add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt4-base-dir "/Qt/qconfig-dist.h"))
;; (add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt4-base-dir "/Qt/qglobal.h"))
