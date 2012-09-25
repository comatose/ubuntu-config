(global-ede-mode 1)

(add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode t)
;; (add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode t)
;; (add-to-list 'semantic-default-submodes 'global-cedet-m3-minor-mode t)
(add-to-list 'semantic-default-submodes 'global-semantic-highlight-func-mode t)
;; (add-to-list 'semantic-default-submodes 'global-semantic-highlight-edits-mode t)
(add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode t)
(add-to-list 'semantic-default-submodes 'global-semantic-decoration-mode t)
;; (add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode t)

;; customisation of modes
(defun alexott/cedet-hook ()
  (local-set-key (kbd "C-<return>") 'semantic-ia-complete-symbol)
  ;; (local-set-key "\C-c?" 'semantic-ia-complete-symbol-menu)

  (local-set-key "\C-c>" 'semantic-complete-analyze-inline)
  (local-set-key "\C-c=" 'semantic-decoration-include-visit)

  (local-set-key "\C-cj" 'semantic-ia-fast-jump)
  (local-set-key "\C-cq" 'semantic-ia-show-doc)
  (local-set-key "\C-cs" 'semantic-ia-show-summary)
  (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle)
  ;; (local-set-key (kbd "C-c <left>") 'semantic-tag-folding-fold-block)
  ;; (local-set-key (kbd "C-c <right>") 'semantic-tag-folding-show-block)

  (add-to-list 'ac-sources 'ac-source-semantic)
  )
;; (add-hook 'semantic-init-hooks 'alexott/cedet-hook)
(add-hook 'c-mode-common-hook 'alexott/cedet-hook)
(add-hook 'lisp-mode-hook 'alexott/cedet-hook)
(add-hook 'scheme-mode-hook 'alexott/cedet-hook)
(add-hook 'emacs-lisp-mode-hook 'alexott/cedet-hook)
(add-hook 'erlang-mode-hook 'alexott/cedet-hook)

(defun alexott/c-mode-cedet-hook ()
  ;; (local-set-key "\C-ct" 'eassist-switch-h-cpp)
  ;; (local-set-key "\C-xt" 'eassist-switch-h-cpp)
  ;; (local-set-key "\C-ce" 'eassist-list-methods)
  (local-set-key "\C-c\C-r" 'semantic-symref)
  (local-set-key (kbd ".") 'semantic-complete-self-insert)
  (local-set-key (kbd ">") 'semantic-complete-self-insert)

  ;; (add-to-list 'ac-sources 'ac-source-etags)
  (add-to-list 'ac-sources 'ac-source-gtags)
  )
(add-hook 'c-mode-common-hook 'alexott/c-mode-cedet-hook)

(semantic-mode 1)

(global-semanticdb-minor-mode 1) 
