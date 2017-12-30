;;; initfile --- Summary:
;;; Commentary:
;; Emacs 24.5.1
;; Many places were referenced in constructing this file.  Here are some:
;; http://aaronbedra.com/emacs.d/
;; https://github.com/atilaneves/cmake-ide
;; http://stackoverflow.com/questions/13825188/suppress-c-namespace-indentation-in-emacs
;; http://syamajala.github.io/c-ide.html
;; http://tuhdo.github.io/c-ide.html
;; http://tuhdo.github.io/helm-intro.html
;; https://github.com/AndreaCrotti/yasnippet-snippets
;;; Code:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start emacs server
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(server-start)

;; We don't want to type yes and no all the time so, do y and n
(defalias 'yes-or-no-p 'y-or-n-p)
;; Disable the horrid auto-save
(setq auto-save-default nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set packages to install
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(prelude-require-packages
 '(ace-window async auctex auto-complete clang-format cmake-ide
         cmake-mode company company-irony
         company-irony-c-headers dash epl flycheck
         flycheck-irony flycheck-pyflakes
         google-c-style helm helm-core
         helm-flycheck helm-ls-git helm-ls-hg
         hungry-delete iedit irony
         let-alist levenshtein magit markdown-mode pkg-info
         popup seq solarized-theme switch-window vlf web-mode
         window-numbering writegood-mode yasnippet))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Configure flycheck
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; If for some reason you're not using CMake you can use a tool like
;; bear (build ear) to get a compile_commands.json file in the root
;; directory of your project. flycheck can use this as well to figure
;; out how to build your project. If that fails, you can also
;; manually include directories by add the following into a
;; ".dir-locals.el" file in the root directory of the project. You can
;; set any number of includes you would like and they'll only be
;; used for that project. Note that flycheck calls
;; "cmake CMAKE_EXPORT_COMPILE_COMMANDS=1 ." so if you should have
;; reasonable (working) defaults for all your CMake variables in
;; your CMake file.
;; (setq flycheck-clang-include-path (list "/path/to/include/" "/path/to/include2/"))
;;
;; With CMake, you might need to pass in some variables since the defaults
;; may not be correct. This can be done by specifying cmake-compile-command
;; in the project root directory. For example, I need to specify CHARM_DIR
;; and I want to build in a different directory (out of source) so I set:
;; ((nil . ((cmake-ide-build-dir . "../ParBuild/"))))
;; ((nil . ((cmake-compile-command . "-DCHARM_DIR=/Users/nils/SpECTRE/charm/"))))
;; You can also set arguments to the C++ compiler, I use clang so:
;; ((nil . ((cmake-ide-clang-flags-c++ . "-I/Users/nils/SpECTRE/Amr/"))))
;;
;; You can force cmake-ide-compile to compile in parallel by changing:
;; "make -C " to "make -j8 -C " in the cmake-ide.el file and then force
;; recompiling the directory using M-x byte-force-recompile
;; Require flycheck to be present
(require 'flycheck)

;; Turn flycheck on everywhere
(global-flycheck-mode)

;; Use flycheck-pyflakes for python. Seems to work a little better.
(require 'flycheck-pyflakes)

(flyspell-mode -1)

(transient-mark-mode -1)

;; ace-window
(global-set-key (kbd "M-p") 'ace-window)
(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
(setq aw-dispatch-always t)
(defvar aw-dispatch-alist
  '((?0 aw-delete-window " Ace - Delete Window")
    (?m aw-swap-window " Ace - Swap Window")
    (?o aw-flip-window)
    (?c aw-split-window-fair " Ace - Split Fair Window")
    (?2 aw-split-window-vert " Ace - Split Vert Window")
    (?3 aw-split-window-horz " Ace - Split Horz Window")
    (?1 delete-other-windows " Ace - Maximize Window")
    (?1 delete-other-windows)
    (?b balance-windows))
  "List of actions for `aw-dispatch-default'.")

;; switch-window
(require 'switch-window)
(global-set-key (kbd "C-x o") 'switch-window)
(global-set-key (kbd "C-x 1") 'switch-window-then-maximize)
(global-set-key (kbd "C-x 2") 'switch-window-then-split-below)
(global-set-key (kbd "C-x 3") 'switch-window-then-split-right)
(global-set-key (kbd "C-x 0") 'switch-window-then-delete)

(setq switch-window-shortcut-style 'qwerty)
(setq switch-window-qwerty-shortcuts
      '("a" "s" "d" "f" "j" "k" "l" ";" "w" "e" "i" "o"))

;; iedit-mode
(require 'iedit)

(when (file-exists-p "~/src/rtags/build/src")
  (load-file "~/src/rtags/build/src/rtags.el")
  (load-file "~/src/rtags/build/src/company-rtags.el")
  (load-file "~/src/rtags/build/src/flycheck-rtags.el")
  (load-file "~/src/rtags/build/src/helm-rtags.el")

  ;; Load rtags and start the cmake-ide-setup process
  (require 'rtags)
  (rtags-enable-standard-keybindings c-mode-base-map "C-x r ")
  (setq rtags-tramp-enabled t)

  ;; Set rtags to enable completions and use the standard keybindings.
  ;; A list of the keybindings can be found at:
  ;; http://syamajala.github.io/c-ide.html
  (setq rtags-autostart-diagnostics t)
  (rtags-diagnostics)
  (setq rtags-completions-enabled t)
  (rtags-enable-standard-keybindings)

  (setq rtags-use-helm t)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Setup cmake-ide
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'cmake-ide)
(cmake-ide-setup)
;; Set cmake-ide-flags-c++ to use C++11
(setq cmake-ide-flags-c++ (append '("-std=c++1z")))
;; We want to be able to compile with a keyboard shortcut
(global-set-key (kbd "C-c m") 'cmake-ide-compile)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set up helm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Load helm and set M-x to helm, buffer to helm, and find files to herm
(require 'helm-config)
(require 'helm)
(require 'helm-ls-git)

;; Use C-c h for helm instead of C-x c
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-b") 'helm-buffers-list)
(global-set-key (kbd "C-x C-f") 'helm-find-files)

(setq
 helm-split-window-in-side-p           t
                                        ; open helm buffer inside current window,
                                        ; not occupy whole other window
 helm-move-to-line-cycle-in-source     t
                                        ; move to end or beginning of source when
                                        ; reaching top or bottom of source.
 helm-ff-search-library-in-sexp        t
                                        ; search for library in `require' and `declare-function' sexp.
 helm-scroll-amount                    8
                                        ; scroll 8 lines other window using M-<next>/M-<prior>
 helm-ff-file-name-history-use-recentf t
 ;; Allow fuzzy matches in helm semantic
 helm-semantic-fuzzy-match t
 helm-imenu-fuzzy-match    t)
;; Have helm automaticaly resize the window
(helm-autoresize-mode 1)
(require 'helm-flycheck) ;; Not necessary if using ELPA package
(eval-after-load 'flycheck
  '(define-key flycheck-mode-map (kbd "C-c ! h") 'helm-flycheck))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set up code completion with company and irony
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'company)
;; (require 'company-rtags)
(global-company-mode)

;; Enable semantics mode for auto-completion
(require 'cc-mode)
(require 'semantic)
(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)
(semantic-mode 1)

(require 'irony)
(require 'company-irony-c-headers)
(require 'cl)

;; irony-mode hook that is called when irony is triggered
(defun my-irony-mode-hook ()
  "Custom irony mode hook to remap keys."
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))

(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

;; company-irony setup, c-header completions
(add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)
;; Remove company-semantic because it has higher precedance than company-clang
;; Using RTags completion is also faster than semantic, it seems. Semantic
;; also provides a bunch of technically irrelevant completions sometimes.
;; All in all, RTags just seems to do a better job.
(setq company-backends (delete 'company-semantic company-backends))
;; Enable company-irony and several other useful auto-completion modes
;; We don't use rtags since we've found that for large projects this can cause
;; async timeouts. company-semantic (after company-clang!) works quite well
;; but some knowledge some knowledge of when best to trigger is still necessary.
(eval-after-load 'company
  '(add-to-list
    'company-backends '(company-irony-c-headers
                        company-irony company-yasnippet
                        company-clang company-rtags)
    )
  )

(defun my-disable-semantic ()
  "Disable the company-semantic backend."
  (interactive)
  (setq company-backends (delete '(company-irony-c-headers
                                   company-irony company-yasnippet
                                   company-clang company-rtags
                                   company-semantic) company-backends))
  (add-to-list
   'company-backends '(company-irony-c-headers
                       company-irony company-yasnippet
                       company-clang company-rtags))
  )
(defun my-enable-semantic ()
  "Enable the company-semantic backend."
  (interactive)
  (setq company-backends (delete '(company-irony-c-headers
                                   company-irony company-yasnippet
                                   company-clang) company-backends))
  (add-to-list
   'company-backends '(company-irony-c-headers
                       company-irony company-yasnippet company-clang))
  )

;; Zero delay when pressing tab
(setq company-idle-delay 0)
(define-key c-mode-map [(tab)] 'company-complete)
(define-key c++-mode-map [(tab)] 'company-complete)
;; Delay when idle because I want to be able to think without
;; completions immediately being called and slowing me down.
(setq company-idle-delay 0.2)

;; Prohibit semantic from searching through system headers. We want
;; company-clang to do that for us.
(setq-mode-local c-mode semanticdb-find-default-throttle
                 '(local project unloaded recursive))
(setq-mode-local c++-mode semanticdb-find-default-throttle
                 '(local project unloaded recursive))

(semantic-remove-system-include "/usr/include/" 'c++-mode)
(semantic-remove-system-include "/usr/local/include/" 'c++-mode)
(add-hook 'semantic-init-hooks
          'semantic-reset-system-include)

;; rtags Seems to be really slow sometimes so I disable using
;; it with irony mode
;; (require 'flycheck-rtags)
;; (defun my-flycheck-rtags-setup ()
;;   (flycheck-select-checker 'rtags)
;;   ;; RTags creates more accurate overlays.
;;   (setq-local flycheck-highlighting-mode nil)
;;   (setq-local flycheck-check-syntax-automatically nil))
;; ;; c-mode-common-hook is also called by c++-mode
;; (add-hook 'c-mode-common-hook #'my-flycheck-rtags-setup)

;; (eval-after-load 'flycheck
;;   '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))

;; Add flycheck to helm
(require 'helm-flycheck) ;; Not necessary if using ELPA package
(eval-after-load 'flycheck
  '(define-key flycheck-mode-map (kbd "C-c ! h") 'helm-flycheck))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Window numbering
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package window-numbering installed from package list
;; Allows switching between buffers using meta-(# key)
(when (display-graphic-p)
  (window-numbering-mode t)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C++ keys
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'cc-mode)
;; Compiling:
(define-key c++-mode-map (kbd "C-c C-c") 'compile)
;; Change compilation command:
(setq compile-command "cmake --build build")


;; Load glasses mode, which turns camel notation from
;; thisBullshitThatICantRead to
;; this_Bullshit_That_I_Cant_Read. Much better...
;; (add-hook 'c-mode-common-hook 'glasses-mode)

;; Change tab key behavior to insert spaces instead
(setq-default indent-tabs-mode nil)

;; Set the number of spaces that the tab key inserts (usually 2 or 4)
(setq c-basic-offset 2)
;; Set the size that a tab CHARACTER is interpreted as
;; (unnecessary if there are no tab characters in the file!)
(setq tab-width 2)
;; Set python tab width...
(setq-default tab-width 2)
(setq-default python-indent 2)
;; (setq-default python-indent-offset 0)
(add-hook 'python-mode-hook
          (lambda ()
            (setq tab-width 2)))

;; We want to be able to see if there is a tab character vs a space.
;; global-whitespace-mode allows us to do just that.
;; Set whitespace mode to only show tabs, not newlines/spaces.
(require 'whitespace)
(setq whitespace-style '(tabs tab-mark))
;; Turn on whitespace mode globally.
(global-whitespace-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Clang-format
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; clang-format can be triggered using C-M-tab
;; (load "~/.emacs.d/clang-format.el")
(require 'clang-format)
(global-set-key [C-M-tab] 'clang-format-region)
;; Create clang-format file using google style
;; clang-format -style=google -dump-config > .clang-format

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org-Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'org-mode-default)
(setq org-log-done 'time
      org-todo-keywords '((sequence "TODO" "INPROGRESS" "DONE"))
      org-todo-keyword-faces '(("INPROGRESS" . (:foreground "blue" :weight bold))))
(add-hook 'org-mode-hook
          (lambda ()
            (flyspell-mode)))
(add-hook 'org-mode-hook
          (lambda ()
            (writegood-mode)))

(defun comatose/c-mode-hook ()
  ;; Enable Google style things
  ;; This prevents the extra two spaces in a namespace that Emacs
  ;; otherwise wants to put... Gawd!
  (google-set-c-style)

  ;; Autoindent using google style guide
  (google-make-newline-indent)

  ;; Enable hide/show of code blocks
  (hs-minor-mode)

  ;; (c-toggle-hungry-state 1)
  ;; (subword-mode 1)
  ;; (global-cwarn-mode 1)

  ;; (define-key c-mode-base-map "\C-j" 'c-context-line-break)

  (irony-mode)

  (setq gdb-many-windows t)
  (setq gdb-show-threads-by-default t)

  ;; Force flycheck to always use c++1z support. We use
  ;; the clang language backend so this is set to clang
  (setq flycheck-clang-language-standard "c++1z")

  ;; (rtags-start-process-unless-running)
  ;; (setq rtags-autostart-diagnostics t)
  ;; (rtags-diagnostics)
  ;; (setq rtags-completions-enabled t)
  ;; (push 'company-rtags company-backends)
  ;; (setq rtags-display-result-backend 'helm)

  ;; (require 'flycheck-rtags)
  ;; (flycheck-select-checker 'rtags)
  ;; (setq-local flycheck-highlighting-mode nil) ;; RTags creates more accurate overlays.
  ;; (setq-local flycheck-check-syntax-automatically nil)
  )

(add-hook 'prelude-c-mode-common-hook 'comatose/c-mode-hook 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General Tweaks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq kill-whole-line t)
;; turn on highlight matching brackets when cursor is on one
(show-paren-mode 1)
;; Overwrite region selected
(delete-selection-mode t)
;; Show column numbers by default
(setq column-number-mode t)
;; Use CUA to delete selections
(setq cua-mode t)
(setq cua-enable-cua-keys nil)
;; Prevent emacs from creating a bckup file filename~
(setq make-backup-files nil)
;; Show date and time in modeline
(display-time)
;; Settings for searching
(setq-default case-fold-search nil ;case sensitive searches by default
              search-highlight t) ;hilit matches when searching
;; Highlight the line we are currently on
(global-hl-line-mode 1)
;; Disable the toolbar at the top since it's useless
(if (functionp 'tool-bar-mode) (tool-bar-mode -1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Load hungry Delete, caus we're lazy
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set hungry delete:
(require 'hungry-delete)
(global-hungry-delete-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Syntax Highlighting in GUDA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Load CUDA mode so we get syntax highlighting in .cu files
(autoload 'cuda-mode "~/.emacs.d/plugins/cuda-mode.el")
(add-to-list 'auto-mode-alist '("\\.cu\\'" . cuda-mode))
(add-to-list 'auto-mode-alist '("\\.cuh\\'" . cuda-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Global Keyboard Shortcuts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; Set help to C-?
;; (global-set-key (kbd "C-?") 'help-command)
;; Set mark paragraph to M-?
(global-set-key (kbd "M-?") 'mark-paragraph)
;; ;; Set backspace to C-h
;; (global-set-key (kbd "C-h") 'delete-backward-char)
;; ;; Set backspace word to M-h
;; (global-set-key (kbd "M-h") 'backward-kill-word)
;; Use meta+tab word completion
(global-set-key (kbd "M-TAB") 'dabbrev-expand)
;; ;; Easy undo key
;; (global-set-key (kbd "C-/") 'undo)
;; ;; Comment or uncomment the region
;; (global-set-key (kbd "C-c ;") 'comment-or-uncomment-region)
;; Indent after a newline, if required by syntax of language
(global-set-key (kbd "C-m") 'newline-and-indent)
;; Load the compile ocmmand
(global-set-key (kbd "C-c C-c") 'compile)
;; ;; Undo, basically C-x u
;; (global-set-key (kbd "C-/") 'undo)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; Flyspell Mode for Spelling Corrections
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'flyspell)
;; ;; The welcome message is useless and can cause problems
;; (setq flyspell-issue-welcome-flag nil)
;; ;; Fly spell keyboard shortcuts so no mouse is needed
;; ;; Use helm with flyspell
;; (define-key flyspell-mode-map (kbd "<f8>") 'helm-flyspell-correct)
;; ;; (global-set-key (kbd "<f8>") 'ispell-word)
;; (global-set-key (kbd "C-S-<f8>") 'flyspell-mode)
;; (global-set-key (kbd "C-M-<f8>") 'flyspell-buffer)
;; (global-set-key (kbd "C-<f8>") 'flyspell-check-previous-highlighted-word)
;; (global-set-key (kbd "M-<f8>") 'flyspell-check-next-highlighted-word)
;; ;; Set the way word highlighting is done
;; (defun flyspell-check-next-highlighted-word ()
;;   "Custom function to spell check next highlighted word."
;;   (interactive)
;;   (flyspell-goto-next-error)
;;   (ispell-word)
;;   )

;; ;; Spell check comments in c++ and c common
;; (add-hook 'c++-mode-hook  'flyspell-prog-mode)
;; (add-hook 'c-mode-common-hook 'flyspell-prog-mode)

;; ;; Enable flyspell in text mode
;; (if (fboundp 'prog-mode)
;;     (add-hook 'prog-mode-hook 'flyspell-prog-mode)
;;   (dolist (hook '(lisp-mode-hook emacs-lisp-mode-hook scheme-mode-hook
;;                                  clojure-mode-hook ruby-mode-hook yaml-mode
;;                                  python-mode-hook shell-mode-hook php-mode-hook
;;                                  css-mode-hook haskell-mode-hook caml-mode-hook
;;                                  nxml-mode-hook crontab-mode-hook perl-mode-hook
;;                                  tcl-mode-hook javascript-mode-hook))
;;     (add-hook hook 'flyspell-prog-mode)))

;; (dolist (hook '(text-mode-hook))
;;   (add-hook hook (lambda () (flyspell-mode 1))))
;; (dolist (hook '(change-log-mode-hook log-edit-mode-hook))
;;   (add-hook hook (lambda () (flyspell-mode -1))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Magit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (global-set-key (kbd "M-g M-s") 'magit-status)
;; (global-set-key (kbd "M-g M-c") 'magit-checkout)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cmake-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'cmake-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Load c++-mode when opening charm++ interface files
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'auto-mode-alist '("\\.ci\\'" . c++-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Appearance
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The deeper blue theme is loaded but the resulting text
;; appears black in Aquamacs. This can be fixed by setting
;; the font color under Menu Bar->Options->Appearance->Font For...
;; and then setting "Adopt Face and Frame Parameter as Frame Default"
(when window-system
  (load-theme 'solarized-dark)
  )
;; (if window-system
;;     (load-theme 'deeper-blue t)
;;   (load-theme 'wheatgrass t))

;; Set the background color for the header.
(custom-set-faces '(header-line ((t (:background "#003366")))))

;; company-mode colors. These are borrowed from Solarized and tweaked to look better
;; with deeper-blue. Could use improvement but I have no time.
(custom-set-faces
 '(company-template-field ((t (:background "#7B6000" :foreground "#073642"))))
 '(company-tooltip ((t (:background "black" :foreground "DeepSkyBlue1"))))
 '(company-tooltip-selection ((t (:background "DodgerBlue4" :foreground "CadetBlue1"))))
 '(company-tooltip-mouse ((t (:background "DodgerBlue4" :foreground "CadetBlue1"))))
 '(company-tooltip-mouse ((t (:background "#69CABF" :foreground "#00736F"))))
 '(company-tooltip-common ((t (:foreground "#93a1a1" :underline t))))
 '(company-tooltip-common-selection ((t (:foreground "#93a1a1" :underline t))))
 '(company-tooltip-annotation ((t (:foreground "#93a1a1" :background "#073642"))))
 '(company-scrollbar-fg ((t (:foreground "#002b36" :background "#839496"))))
 '(company-scrollbar-bg ((t (:background "#073642" :foreground "#2aa198"))))
 '(company-preview ((t (:background "#073642" :foreground "#2aa198"))))
 '(company-preview-common ((t (:foreground "#93a1a1" :underline t))))
 )

;; I don't care to see the splash screen
(setq inhibit-splash-screen t)

(when (display-graphic-p)
  ;; Hide the scroll bar
  (scroll-bar-mode -1)
  (defvar my-font-size 110)
  ;; Make mode bar small
  (set-face-attribute 'mode-line nil  :height my-font-size)
  ;; Set the header bar font
  (set-face-attribute 'header-line nil  :height my-font-size)
  ;; Set default window size and position
  (setq default-frame-alist
        '((top . 0) (left . 0) ;; position
          (width . 110) (height . 90) ;; size
          ))
  ;; Set the font to size 9 (90/10).
  (set-face-attribute 'default nil :height my-font-size)
  )

(unless (display-graphic-p)
  (setq linum-format "%d "))

;; Enable line numbers on the LHS
(global-linum-mode 1)

(setq-default indicate-empty-lines t)
(when (not indicate-empty-lines)
  (toggle-indicate-empty-lines))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Enable which function mode and set the header line to display both the
;; path and the function we're in
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(which-function-mode t)

;; Remove function from mode bar
(setq mode-line-misc-info
      (delete (assoc 'which-func-mode
                     mode-line-misc-info) mode-line-misc-info))


(defmacro with-face
    (str &rest properties)
  `(propertize ,str 'face (list ,@properties)))

(defun sl/make-header ()
  "."
  (let* ((sl/full-header (abbreviate-file-name buffer-file-name))
         (sl/header (file-name-directory sl/full-header))
         (sl/drop-str "[...]")
         )
    (if (> (length sl/full-header)
           (window-body-width))
        (if (> (length sl/header)
               (window-body-width))
            (progn
              (concat (with-face sl/drop-str
                                 :background "blue"
                                 :weight 'bold
                                 )
                      (with-face (substring sl/header
                                            (+ (- (length sl/header)
                                                  (window-body-width))
                                               (length sl/drop-str))
                                            (length sl/header))
                                 ;; :background "red"
                                 :weight 'bold
                                 )))
          (concat
           (with-face sl/header
                      ;; :background "red"
                      :foreground "red"
                      :weight 'bold)))
      (concat (if window-system ;; In the terminal the green is hard to read
                  (with-face sl/header
                             ;; :background "green"
                             ;; :foreground "black"
                             :weight 'bold
                             :foreground "#8fb28f"
                             )
                (with-face sl/header
                           ;; :background "green"
                           ;; :foreground "black"
                           :weight 'bold
                           :foreground "blue"
                           ))
              (with-face (file-name-nondirectory buffer-file-name)
                         :weight 'bold
                         ;; :background "red"
                         )))))

(defun sl/display-header ()
  "Create the header string and display it."
  ;; The dark blue in the header for which-func is terrible to read.
  ;; However, in the terminal it's quite nice
  (if window-system
      (custom-set-faces
       '(which-func ((t (:foreground "#8fb28f")))))
    (custom-set-faces
     '(which-func ((t (:foreground "blue"))))))
  ;; Set the header line
  (setq header-line-format

        (list "-"
              '(which-func-mode ("" which-func-format))
              '("" ;; invocation-name
                (:eval (if (buffer-file-name)
                           (concat "[" (sl/make-header) "]")
                         "[%b]")))
              )
        )
  )
;; Call the header line update
(add-hook 'buffer-list-update-hook
          'sl/display-header)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package: yasnippet
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'yasnippet)
;; To get a bunch of extra snippets that come in super handy see:
;; https://github.com/AndreaCrotti/yasnippet-snippets
;; or use:
;; git clone https://github.com/AndreaCrotti/yasnippet-snippets.git ~/.emacs.d/yassnippet-snippets/
(add-to-list 'yas-snippet-dirs "~/.emacs.d/yasnippet-snippets/")
(yas-global-mode 1)
(yas-reload-all)

(provide '.emacs)
;;; .emacs ends here
