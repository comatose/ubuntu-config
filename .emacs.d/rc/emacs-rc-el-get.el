(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil t)
  (url-retrieve
   "https://raw.github.com/dimitri/el-get/master/el-get-install.el"
   (lambda (s)
     (let (el-get-master-branch)
       (goto-char (point-max))
       (eval-print-last-sexp)))))

(setq el-get-user-package-directory "~/.emacs.d/el-get-init-files/")

;; now set our own packages
(setq my:el-get-packages
      '(
	el-get
	;; cedet
	auto-complete
	notify
	flymake-cursor
	haskell-mode
	ghc-mod
	xcscope
	bookmark+
	smex
	magit
	yasnippet
	idomenu
	xgtags
	fuzzy
	git-emacs
	goto-last-change
	visible-mark
	ac-ghc-mod
	;; auto-complete-extension
	member-functions
	;; package
	sr-speedbar
	))

;; set local recipes
(setq
 el-get-sources
 '(
   (:name goto-last-change		; move pointer back to last change
	  :after (progn
		   ;; when using AZERTY keyboard, consider C-x C-_
		   (global-set-key (kbd "C-x C-/") 'goto-last-change)))
   (:name visible-mark
	  :after (progn
		   (require 'visible-mark)
		   (global-visible-mark-mode 1)))
   (:name auto-complete
	  :after (progn 
		   (require 'auto-complete)
		   (require 'auto-complete-config)
		   (global-auto-complete-mode 1)
		   (setq ac-auto-start nil)
		   (define-key ac-mode-map (kbd "M-<return>") 'auto-complete)))
   (:name haskell-mode
	  :after (progn
		   (add-hook 
		    'haskell-mode-hook 
		    '(lambda ()
		       ;; (imenu-add-menubar-index)
		       ;; (turn-on-font-lock)
		       ;; (turn-off-haskell-doc-mode)
		       ;; (setq haskell-doc-show-global-types t)

		       (turn-on-haskell-indentation)
		       (capitalized-words-mode)

		       (turn-on-haskell-decl-scan)
		       (define-key haskell-mode-map (kbd "C-M-p") 'haskell-ds-backward-decl)
		       (define-key haskell-mode-map (kbd "C-M-n") 'haskell-ds-forward-decl)

		       (speedbar-add-supported-extension ".hs")

		       (define-key haskell-mode-map (kbd "C-c C-h") 'haskell-hoogle)
		       (define-key haskell-mode-map (kbd "C-c C-g") 'haskell-hayoo)

		       (setq haskell-hoogle-command "hoogle-info")

		       (setq haskell-stylish-on-save t)
		       (setq haskell-tags-on-save t)

		       ;; resolve confliction with ghc-save-buffer
		       (defadvice ghc-save-buffer
		       	 (before stylish-and-hasktag activate)
		       	 (haskell-mode-save-buffer)
		       	 )
		       )
		    t)))
   (:name ghc-mod
	  :after (progn
		   (autoload 'ghc-init "ghc" nil t)
		   (add-hook 'haskell-mode-hook '(lambda () (ghc-init) (flymake-mode)) t)
		   ))
   (:name ac-ghc-mod
	  :after (progn
		   (require 'ac-ghc-mod)
		   (add-hook 'haskell-mode-hook
			     (lambda ()
			       (mapc (lambda (x) (add-to-list 'ac-sources x))
				     '(ac-source-ghc-module
				      ac-source-ghc-symbol
				      ac-source-ghc-pragmas
				      ac-source-ghc-langexts))) t)
		   )
	  )
   (:name bookmark+
	  :after (progn
		   (global-set-key (kbd "<S-up>") 'bmkp-previous-bookmark)
		   (global-set-key (kbd "<S-down>") 'bmkp-next-bookmark)

		   (setq bmkp-auto-light-when-set 'any-bookmark)
		   (setq bmkp-auto-light-when-jump 'any-bookmark)
		   (setq bmkp-default-bookmark-file "~/.emacs.d/.bookmarks")
		   (setq bmkp-last-as-first-bookmark-file nil)
		   ))
   (:name smex
	  :after (progn
		   (setq smex-save-file "~/.emacs.d/.smex-items")
		   (define-key ctl-x-map (kbd "C-m") 'smex)
		   (define-key ctl-x-map (kbd "m") 'smex-major-mode-commands)
		   ))
   (:name magit
	  :after (progn
		   (define-key ctl-x-map (kbd "C-z") 'magit-status)
		   ))
   (:name yasnippet
	  :after (progn
		   (setq yas/trigger-key "<C-tab>") ;; make sure this is before yas/initialize
		   (yas/global-mode 1)
		   (yas/load-directory "~/.emacs.d/el-get/yasnippet/snippets")
		   ))
   )
 )


;; install new packages and init already installed packages
(el-get 'sync my:el-get-packages)
