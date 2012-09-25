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
	auto-complete
	ac-ghc-mod
	auto-complete-extension
	member-functions
	;; package
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
   (:name member-functions
	  :after (progn
		   (require 'member-functions)
		   (add-hook 'c++-mode-hook 
			     (lambda ()
			       (let* ((c-file (buffer-file-name))
			       ;; (let* ((c-file (buffer-file-name (current-buffer)))
				      (h-file-list (list (concat (substring c-file 0 -3 ) "h")
							 (concat (substring c-file 0 -3 ) "hpp")
							 (concat (substring c-file 0 -1 ) "h")
							 (concat (substring c-file 0 -1 ) "hpp"))))
				 (if (or (equal (substring c-file -2 ) ".c")
					 (equal (substring c-file -4 ) ".cpp"))
				     (mapcar (lambda (h-file)
					       (if (file-exists-p h-file)
						   (expand-member-functions h-file c-file)))
					     h-file-list))))

			     )))
   (:name haskell-mode
	  :after (progn
		   ;; Add the dir for loading haskell-site-file.
		   ;; (load-file "~/.emacs.d/init-haskell-mode.el")

		   ;; Override and enhance the settings of the above.
		   ;; (add-hook 
		   ;;  'haskell-mode-hook 
		   ;;  '(lambda () 
		   ;; (load "haskell-site-file")
		   ;; (load "haskell-process")
		   ;; (load "haskell-session")
		   ;; (load "haskell-interactive-mode")

		   ;; (setq haskell-process-type 'ghci)

		   ;; (turn-off-haskell-simple-indent)
		   ;; (define-key haskell-mode-map (kbd "<return>") nil)
		   ;; (define-key haskell-mode-map (kbd "C-<return>") nil)
		   ;; (turn-on-haskell-indentation)

		   ;; (turn-on-haskell-doc-mode)
		   ;; (font-lock-mode)

		   ;; (define-key haskell-mode-map (kbd "C-c C-g") 'haskell-hoogle)
		   ;; (define-key haskell-mode-map (kbd "C-c C-h") 'haskell-hayoo)
		   ;; 	 )
		   ;; t)
		   ))
   (:name ghc-mod
	  :after (progn
		   (autoload 'ghc-init "ghc" nil t)
		   (add-hook 'haskell-mode-hook '(lambda () (ghc-init) (flymake-mode)))
		   ))
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
   ))

;; install new packages and init already installed packages
(el-get 'sync my:el-get-packages)
