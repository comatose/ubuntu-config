;; (prelude-require-packages '(
;;                             emacs-eclim
;;                             ))

;; (add-hook 'after-init-hook
;;           (lambda ()
;;             (require 'eclim)
;;             (global-eclim-mode)
;;             (require 'eclimd)
;;             (setq eclimd-default-workspace "~/workspace")

;;             ;; add the emacs-eclim source
;;             (require 'ac-emacs-eclim-source)
;;             (ac-emacs-eclim-config)

;;             (require 'company-emacs-eclim)
;;             (company-emacs-eclim-setup)
;;             )
;;           t)
