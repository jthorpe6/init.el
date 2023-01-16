(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("7f6d4aebcc44c264a64e714c3d9d1e903284305fd7e319e7cb73345a9994f5ef" default))
 '(package-selected-packages
   '(vterm flycheck-swift swift-mode go-autocomplete ob-go ac-js2 nodejs-repl gitignore-mode gitignore-snippets use-package-hydra poetry ox-slack ox-ioslide exec-path-from-shell wttrin plain-org-wiki csharp-mode csv-mode bash-completion nord-theme powershell elixir-mode go-mode jdee ox-tufte ox-slimhtml ox-impress-js ox-html5slide ox-haunt ox-gfm shell-pop flyspell-correct-ivy pylint python-pylint exwm org org-bullets smartparens powerline use-package)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(setq gc-cons-threshold 50000000)

(setq gnutls-min-prime-bits 4096)

(require 'package)

(setq package-archives '(("gnu"       . "http://elpa.gnu.org/packages/")
			 ("melpa"     . "https://melpa.org/packages/")))

;;(package-initialize)

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

(use-package diminish
  :ensure t)

(toggle-frame-maximized)

(desktop-save-mode 1)

(set-charset-priority 'unicode)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(setq ring-bell-function 'ignore)

(menu-bar-mode -1)
(if (display-graphic-p)
    (progn
      (tool-bar-mode -1)
      (scroll-bar-mode -1)))

(global-visual-line-mode t)

(defadvice mouse-save-then-kill (around mouse2-copy-region activate)
  (when (region-active-p)
    (copy-region-as-kill (region-beginning) (region-end)))
  ad-do-it)

(global-font-lock-mode 1)

(set-window-margins nil 15)

(setq column-number-mode t)

(fset 'yes-or-no-p 'y-or-n-p)

(setq standard-indent 2)

(setq python-indent-guess-indent-offset nil)

(global-auto-revert-mode t)

(setq-default find-file-visit-truename t)

(setq create-lockfiles nil)

(setq make-backup-files nil)
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(setq inhibit-startup-message t)

(setq-default message-log-max nil)
(kill-buffer "*Messages*")

(add-hook 'minibuffer-exit-hook
      '(lambda ()
	 (let ((buffer "*Completions*"))
	   (and (get-buffer buffer)
		(kill-buffer buffer)))))

(setq initial-scratch-message "")

(setq initial-major-mode 'org-mode)

(setq make-pointer-invisible t)

(delete-selection-mode 1)

(defun kill-current-buffer ()
  (interactive)
  (kill-buffer (current-buffer)))
(global-set-key (kbd "C-x k") 'kill-current-buffer)

(global-set-key (kbd "C-x C-b") 'ibuffer-list-buffers)

(defun split-and-follow-horizontally ()
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 2") 'split-and-follow-horizontally)

(defun split-and-follow-vertically ()
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 3") 'split-and-follow-vertically)

(use-package dired-subtree
  :ensure t
  :config
  (bind-key "<tab>" #'dired-subtree-toggle dired-mode-map)
  (bind-key "<backtab>" #'dired-subtree-cycle dired-mode-map))

(setq dired-listing-switches "-alh")

(global-set-key (kbd "M-3") '(lambda () (interactive) (insert "#")))

(add-to-list 'default-frame-alist '(internal-border-width . 7))

(diminish 'visual-line-mode)

(setq display-time-day-and-date t)
(display-time)


(use-package smartparens
:ensure t
:diminish smartparens-mode
:config
(smartparens-global-mode)
)

(use-package nord-theme
  :ensure t
  :config (load-theme 'nord t))


(setq-default cursor-type 'bar)

(defun toggle-selective-display (column)
  (interactive "P")
  (set-selective-display
   (or column
       (unless selective-display
	 (1+ (current-column))))))

(defun toggle-hiding (column)
  (interactive "P")
  (if hs-minor-mode
      (if (condition-case nil
	      (hs-toggle-hiding)
	    (error t))
	  (hs-show-all))
    (toggle-selective-display column)))
(load-library "hideshow")

(global-set-key (kbd "C-+") 'toggle-hiding)
(global-set-key (kbd "C-\\") 'toggle-selective-display)

(setq tramp-default-method "ssh")
(setq explicit-shell-file-name "/bin/bash")
(setq shell-file-name "/bin/bash")

(server-start)
(setq server-socket-dir "~/.emacs.d/server")

(use-package vterm
  :ensure t
  :config
  (setq vterm-shell "zsh")
  ;;(setq vterm-kill-buffer-on-exit t)
  (add-to-list 'display-buffer-alist
     '("\*vterm\*"
       (display-buffer-in-side-window)
       (window-height . 0.3)
       (side . bottom)
       (slot . 0)))
  :init
  (add-hook 'vterm-exit-functions
     (lambda (_ _)
       (let* ((buffer (current-buffer))
              (window (get-buffer-window buffer)))
         (when (not (one-window-p))
           (delete-window window))
         (kill-buffer buffer))))
  :bind ("C-c t" . 'vterm-other-window)
  )

(use-package eshell
  :init
  (add-hook 'eshell-mode-hook
	    (lambda ()
	      (add-to-list 'eshell-visual-commands "ssh")
	      (add-to-list 'eshell-visual-commands "tail")
	      (add-to-list 'eshell-visual-commands "top")
	      (add-to-list 'eshell-visual-commands "tmux"))
	    )
  )

(defun eshell/clear ()
  "Clear the eshell buffer."
  (let ((inhibit-read-only t))
    (erase-buffer)
    (eshell-send-input)))

(defun eshell-here ()
  (interactive)
    (eshell "new"))

(bind-key "C-!" 'eshell-here)

(use-package exec-path-from-shell
  :ensure t
  :init (exec-path-from-shell-initialize)
)

(use-package multiple-cursors
:ensure t
:bind (("C-c d" . mc/edit-lines)
("C->" . mc/mark-next-like-this)
("C-<" . mc/mark-previous-like-this)
("C-c C-<" . mc/mark-all-like-this))
)

(use-package ivy
:ensure t
:diminish ivy-mode
)

(use-package counsel
:ensure t)

(use-package swiper    
  :ensure t    
  :bind    
  (("C-s" . swiper)    
   ("M-x" . counsel-M-x)    
   ("C-x C-f" . counsel-find-file)    
   ("C-x l" . counsel-locate)
   ("C-x c" . counsel-flycheck)
   ("C-x C-r" . counsel-recentf)
   ("C-c C-r" . ivy-resume)
   ("C-r" . counsel-expression-history))
  :config    
  (ivy-mode 1)
  (setq ivy-count-format "(%d/%d) ")
)

(use-package ivy-rich
:ensure t
:config
(ivy-rich-mode 1)
)

(use-package all-the-icons-ivy-rich
  :ensure t
  :init (all-the-icons-ivy-rich-mode 1))

(use-package ivy-rich
  :ensure t
  :init (ivy-rich-mode 1))

(use-package cheat-sh
  :ensure t)

(use-package which-key
  :ensure t
  :config
  (which-key-mode)
  :diminish 'which-key-mode
)

(use-package popup-kill-ring
  :ensure t
  :bind ("M-y" . popup-kill-ring)
  )

(use-package lsp-mode
  :ensure t
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook ((
         objc-mode
         cc-mode
         c-mode
         c++-mode
         json-mode
         dockerfile-mode
         sql-mode
         yamal-mode
         sh-mode
         ;;ps-mode
         python-mode
         go-mode
         swift-mode
         js-mode
         web-mode
         js-jsx-mode
         typescript-mode
         ) . lsp-deferred)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration)
  :commands lsp
  :config
  (setq lsp-auto-guess-root t)
  (setq lsp-log-io nil)
  (setq lsp-restart 'auto-restart)
  (setq lsp-enable-symbol-highlighting nil)
  (setq lsp-enable-on-type-formatting nil)
  (setq lsp-signature-auto-activate nil)
  (setq lsp-signature-render-documentation nil)
  (setq lsp-diagnostics-provider :flycheck)
  (setq lsp-eldoc-hook nil)
  (setq lsp-modeline-code-actions-enable nil)
  (setq lsp-modeline-diagnostics-enable nil)
  (setq lsp-headerline-breadcrumb-enable nil)
  (setq lsp-semantic-tokens-enable nil)
  (setq lsp-enable-folding nil)
  (setq lsp-enable-imenu nil)
  (setq lsp-enable-snippet nil)
  (setq read-process-output-max (* 1024 1024)) ;; 1MB
  (setq lsp-idle-delay 0.5)
  (setq lsp-enable-links nil)
  :custom
  (lsp-enable-snippet t)
  )

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable nil)
  (setq lsp-ui-doc-header t)
  (setq lsp-ui-doc-include-signature t)
  (setq lsp-ui-doc-border (face-foreground 'default))
  (setq lsp-ui-sideline-show-code-actions t)
  (setq lsp-ui-sideline-delay 0.05)
  )

(use-package lsp-ivy
  :ensure t
  :commands lsp-ivy-workspace-symbol)

(use-package lsp-pyright
  :ensure t
  :init (when (executable-find "python3")
          (setq lsp-pyright-python-executable-cmd "python3"))
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp-deferred)))
  )

(use-package lsp-sourcekit
  :ensure t
  :after lsp-mode
  :config
  (setq lsp-sourcekit-executable (string-trim (shell-command-to-string "xcrun --find sourcekit-lsp")))
  )

(use-package company
  :ensure t
  :hook (prog-mode . company-mode)
  :config
  (setq company-minimum-prefix-length 1)
  (setq company-selection-wrap-around t)
  (setq company-tooltip-align-annotations t)
  (setq company-frontends '(company-pseudo-tooltip-frontend ; show tooltip even for single candidate
                            company-echo-metadata-frontend))
  )

(use-package yasnippet-snippets
  :ensure t)

(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode t)
  :config
  (setq yas-snippet-dirs '("~/.emacs.d/elpa/yasnippet-snippets-20210808.1851/snippets"))
  (yas-reload-all)
  :diminish 'yas-minor-mode
)

(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t)
  :diminish 'flycheck-mode
)

(setq doom-modeline-python-executable "python3")
(setq python-shell-interpreter "python3")
(setq flycheck-python-pycompile-executable "python3"
      flycheck-python-pylint-executable "python3"
      flycheck-python-flake8-executable "python3")
(setq doom-modeline-major-mode-icon nil
      doom-modeline-version t)

(use-package flyspell
     :ensure t
     :defer 1
     :hook ((markdown-mode . flyspell-mode)
            (org-mode . flyspell-mode))
     :custom
     (flyspell-issue-message-flag nil)
     (flyspell-mode 1)
)

   (use-package flyspell-correct-ivy
     :ensure t
     :after flyspell
     :bind (:map flyspell-mode-map
                 ("C-;" . flyspell-correct-at-point))
     ;;("C-;" . flyspell-correct-word-generic))
     :custom (flyspell-correct-interface 'flyspell-correct-ivy))
   (eval-after-load "flyspell"
     '(diminish 'flyspell-mode))

(use-package pipenv
  :hook (python-mode . pipenv-mode)
  :init
  (setq
   pipenv-projectile-after-switch-function
   #'pipenv-projectile-after-switch-extended))

(use-package poetry
  :ensure t)

(use-package bash-completion
  :ensure t
  :config (bash-completion-setup)
)

(use-package dockerfile-mode
:ensure t
:init (add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))
)


(use-package web-mode
  :ensure t
  :mode ("\\.html\\'"
         "\\.css\\'")
  :config
  (progn
    (setq web-mode-code-indent-offset 2)
    (setq web-mode-enable-auto-quoting nil))
)

(use-package web-beautify
    :ensure t
    :bind (:map web-mode-map
           ("C-c b" . web-beautify-html)
           :map js2-mode-map
           ("C-c b" . web-beautify-js))
)

(use-package php-mode
  :ensure t
  :mode ("\\.php\\'")
  )

(use-package js2-mode
  :ensure t
  :mode ("\\.js\\'" . js2-mode)
  )

(use-package go-mode
  :ensure t
  :mode (("\\.go\\'" . go-mode))
  )

(add-to-list 'exec-path (expand-file-name "~/go/bin"))

(use-package powershell
  :ensure t)

(use-package swift-mode
  :ensure t
  :hook (swift-mode . (lambda () (lsp)))
  )

(use-package flycheck-swift
    :ensure t)
(eval-after-load 'flycheck '(flycheck-swift-setup))

(use-package json-mode
  :ensure t
  :mode (("\\.json\\'" . json-mode))
)

(use-package markdown-mode
  :mode "\\.md\\'"
  :ensure t)

(use-package yaml-mode
  :ensure t
  :config (require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-hook 'yaml-mode-hook
          '(lambda () (define-key yaml-mode-map "\C-m" 'newline-and-indent)))
)

(use-package nodejs-repl
  :ensure t)

(use-package ag
  :ensure t)

(use-package ripgrep
  :ensure t)

(setq grep-command "grep --color -n -rsE ")
(setq grep-find-template
   "find <D> <X> -type f <F> -exec grep <C> -n -r -s -E <R> /dev/null \\{\\} +")

(use-package visual-regexp
  :ensure t
  :bind ("C-c r" . vr/replace)
  ("C-c q" . vr/query-replace)
  ("C-c m" . vr/mc-mark))

(use-package magit
  :ensure t
  :commands magit-status
  :config
  (progn
    (magit-auto-revert-mode 1)
    (setq magit-completing-read-function 'ivy-completing-read))
  :init
  (add-hook 'magit-mode-hook 'magit-load-config-extensions)
  :bind
  ("M-g" . magit-status)
)  

(use-package magithub
  :after magit
  :ensure t
  :disabled
  :config (magithub-feature-autoinject t)
)

(use-package git-gutter
  :ensure t
  :config
  (setq git-gutter:update-interval 0.05)
  (global-git-gutter-mode +1)
)

(use-package git-gutter-fringe
  :ensure t
  :config
  (define-fringe-bitmap 'git-gutter-fr:added [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:modified [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:deleted [128 192 224 240] nil nil 'bottom))

(use-package jdecomp
  :ensure t
  :config
(customize-set-variable 'jdecomp-decompiler-paths
                        '((cfr . "~/.local/bin/cfr.jar"))
                        )
)

(use-package ob-http
  :ensure t
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (http . t))))

(setq org-startup-folded t)

(use-package org
  :pin gnu)

(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("sh" . "src shell :results output"))
(add-to-list 'org-structure-template-alist '("py" . "src python :results output"))
(add-to-list 'org-structure-template-alist '("js" . "src js :results output"))
(add-to-list 'org-structure-template-alist '("go" . "src go :results output"))
(add-to-list 'org-structure-template-alist '("http" . "src http"))
(require 'org-tempo)

(org-indent-mode 1)
(add-hook 'org-mode-hook 'org-indent-mode)

(setq org-startup-with-inline-images t)

(setq org-export-with-section-numbers nil)

(use-package org-bullets
   :ensure t
   :init (add-hook 'org-mode-hook 'org-bullets-mode)
)

  (setq org-hide-emphasis-markers t) ;; Just the Italics

  (font-lock-add-keywords 'org-mode
                              '(("^ +\\([-*]\\) "
                                 (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•")))))) ;; Better Bullets for lists


(use-package ox-reveal
  :ensure ox-reveal
  :config
  (setq org-reveal-root "http://cdn.jsdelivr.net/reveal.js/3.0.0/")
  (setq org-reveal-mathjax t)
)

(use-package htmlize
:ensure t)

(setq org-hide-leading-stars t)

(setq org-src-fontify-natively t)

(setq org-src-tab-acts-natively t)

(setq org-html-postamble nil)

(defadvice org-babel-execute-src-block (around load-language nil activate)
  "Load language if needed"
  (let ((language (org-element-property :language (org-element-at-point))))
    (unless (cdr (assoc (intern language) org-babel-load-languages))
      (add-to-list 'org-babel-load-languages (cons (intern language) t))
      (org-babel-do-load-languages 'org-babel-load-languages org-babel-load-languages))
    ad-do-it))

;; dont ask just run the code block
(setq org-confirm-babel-evaluate nil)

;; Set python3
(setq org-babel-python-command "python3")

(use-package ob-go
  :ensure t)


(use-package org-tree-slide
   :ensure t
   :init
   (setq org-tree-slide-skip-outline-level 4)
   (org-tree-slide-simple-profile)
)

(use-package ox-twbs
  :ensure t)
