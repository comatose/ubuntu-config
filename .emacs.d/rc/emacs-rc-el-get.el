(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil t)
  (url-retrieve
   "https://raw.github.com/dimitri/el-get/master/el-get-install.el"
   (lambda (s)
     (let (el-get-master-branch)
       (goto-char (point-max))
       (eval-print-last-sexp)))))

(setq el-get-user-package-directory "~/.emacs.d/el-get-init-files/")

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
   ;; (:name cedet
   ;; 	  :after (progn (load-file "~/.emacs.d/el-get/cedet/cedet-devel-load.el")
   ;; 			(semantic-load-enable-excessive-code-helpers)))
   (:name auto-complete
	  :after (progn 
		   (require 'auto-complete)
		   (require 'auto-complete-config)
		   (global-auto-complete-mode 1)
		   (setq ac-auto-start nil)
		   (define-key ac-mode-map (kbd "M-<return>") 'auto-complete)))
   ))

;; now set our own packages
(setq my:el-get-packages
      '(
	el-get
	git-emacs
	goto-last-change
	visible-mark
	auto-complete
	ac-ghc-mod
	auto-complete-extension
	))

;; install new packages and init already installed packages
(el-get 'sync my:el-get-packages)
