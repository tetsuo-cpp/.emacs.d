(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives
      '(("melpa" . "http://melpa.org/packages/")))
(package-initialize)

;; Install use-package if not already there.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Bootstrap configuration.
(require 'use-package)
(setq use-package-always-ensure t)

;; Ivy completion framework.
(use-package ivy
  :init
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  :bind (("C-c C-r" . 'ivy-resume))
  :config
  (ivy-mode t))

;; Use Ivy for more things.
(use-package counsel
  :bind (("M-x" . 'counsel-M-x)
         ("C-x C-f" . 'counsel-find-file)
         ("C-c g" . 'counsel-git)
         ("C-c j" . 'counsel-git-grep)
         ("C-c k" . 'counsel-ag)
         ("C-x l" . 'counsel-locate)))

;; Enhanced ISearch.
(use-package swiper
  :bind (("C-s" . 'swiper)))

;; Edit Grep buffers.
(use-package wgrep
  :init
  (setq wgrep-enable-key "e")
  (setq wgrep-auto-save-buffer t))

;; Display what is bound to each key.
(use-package which-key
  :config
  (which-key-mode))

;; Bracket completion.
(use-package smartparens
  :config
  (require 'smartparens-config)
  (smartparens-global-mode t))

(use-package rainbow-delimiters
  :init
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

;; Indent with tabs and align with spaces.
(use-package smart-tabs-mode
  :config
  (smart-tabs-insinuate 'c++))

;; Project navigation.
(use-package projectile
  :init
  (setq projectile-completion-system 'ivy)
  (setq projectile-use-git-grep t)
  (setq projectile-enable-caching t)
  :bind (("C-c p G u" . 'projectile-global-up)
         ("C-c p G d" . 'projectile-global-down))
  :config
  (projectile-global-mode)
  ;; Convenient functions for bringing global up and down.
  (defun projectile-global-up ()
    "Start GNU Global Docker container."
    (interactive)
    (shell-command (concat "cd " (projectile-project-root) " && "
                           (concat user-emacs-directory "global/start_global.sh"))))
  (defun projectile-global-down ()
    "Stop GNU Global Docker container."
    (interactive)
    (shell-command (concat user-emacs-directory "global/stop_global.sh"))))

(use-package counsel-projectile
  :config
  (counsel-projectile-mode))

;; Use Ivy completion for CTags.
(use-package counsel-etags
  ;; Using GTags instead for now.
  :disabled
  :bind (("M-." . counsel-etags-find-tag-at-point)
         ("M-]" . counsel-etags-find-tag)))

;; GNU Global (GTags) frontend.
;; Commands are identical to CTags.
(use-package ggtags
  :init
  ;; Use executables under ~/.emacs.d/global.
  ;; (setq ggtags-executable-directory (concat user-emacs-directory "global"))
  :config
  (add-hook 'c++-mode-hook
            (lambda ()
              (ggtags-mode 1))))

;; YASnippet.
(use-package yasnippet
  :init
  (setq yas-indent-line 'auto)
  (setq yas-also-auto-indent-first-line t)
  (setq yas-triggers-in-field t)
  :config
  (setq yas-snippet-dirs (concat user-emacs-directory "snippets"))
  (yas-global-mode t))

(use-package clang-format
  :bind (("C-c f" . 'clang-format-buffer-smart))
  :config
  (defun clang-format-buffer-smart ()
    "Reformat buffer if .clang-format exists in the projectile root."
    (interactive)
    (when (file-exists-p (expand-file-name ".clang-format" (projectile-project-root)))
      (clang-format-buffer))))

(use-package eshell
  :init
  (add-hook 'eshell-mode-hook
	    (lambda ()
	      (add-to-list 'eshell-visual-commands "ssh")
	      (add-to-list 'eshell-visual-commands "less")
	      (add-to-list 'eshell-visual-commands "top")
	      (add-to-list 'eshell-visual-subcommands '("git" "log" "diff" "show"))))
  (setq eshell-destroy-buffer-when-process-dies t))

;; Jump to visible text.
(use-package avy
  :bind (("C-;" . 'avy-goto-line)
         ("C-'" . 'avy-goto-char-2))
  :config
  (avy-setup-default))

;; Rust support.
(use-package rust-mode
  :init
  (setq rust-format-on-save t))

;; Lua support.
(use-package lua-mode)

(use-package nyan-mode
  :init
  (setq nyan-animate-nyancat t)
  (setq nyan-animation-frame-interval 0.1)
  :config
  (nyan-mode))

;; Scheme interaction.
(use-package geiser
  :init
  (setq geiser-active-implementations '(guile)))

;; CMake editing.
(use-package cmake-mode)

;; Graphical system monitor.
(use-package symon
  ;; The fringe display useful information when using Global.
  :disabled
  :init
  (setq symon-sparkline-type 'boxed)
  :config
  (symon-mode))

;; Docker interface.
(use-package docker
  :config
  ;; Docker needs to run with root privileges.
  (defadvice docker (around docker-sudo-fix (action &rest args))
    (let ((default-directory "/sudo::"))
      ad-do-it action args))
  (docker-global-mode))

;; Dockerfile editing.
(use-package dockerfile-mode
  :config
  (add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode)))

;; Enable ido mode for file and buffer switching.
(ido-mode t)
(setq ido-everywhere t)
(setq ido-enable-flex-matching t)

;; Allow remote editing.
(use-package tramp
  :config
  ;; Pick up environment vars and aliases on remote host.
  (setq tramp-remote-path (cons 'tramp-own-remote-path tramp-remote-path)))

;; Enhanced directory traversal.
(require 'dired-x)

;; Indentation.
(setq-default indent-tabs-mode nil)
(defun optiver-cpp-setup ()
  (setq c-default-style "linux"
        c-basic-offset 4
        tab-width 4)
  (c-set-offset 'innamespace 0)
  (c-set-offset 'substatement-open 0)
  (c-set-offset 'inline-open 0))
(add-hook 'c++-mode-hook 'optiver-cpp-setup)

;; Open .h files in C++ mode by default.
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; Use Moe light theme.
(use-package moe-theme
  :init
  (setq moe-theme-highlight-buffer-id nil)
  :config
  (moe-light)
  (moe-theme-set-color 'orange))

;; Set default font.
(set-face-attribute 'default nil :font "Liberation Mono-14")

;; Sort apropos results by relevance.
(setq apropos-sort-by-scores t)

;; Switch windows with M-o for convenience.
(global-set-key (kbd "M-o") 'other-window)

;; Use shift and arrow keys to move between windows.
(windmove-default-keybindings)

;; Resize windows more easily.
(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)

;; Follow compilation output.
(setq compilation-scroll-output t)

;; Delete trailing whitespace on save.
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Customize cursor.
(setq-default cursor-type 'bar)
(set-cursor-color "red")
(blink-cursor-mode 0)
(global-hl-line-mode t)

;; Disable line wrapping.
(setq truncate-lines nil)

;; Disable scroll bar.
(scroll-bar-mode -1)
(menu-bar-mode -1)

;; Make DAbbrev ignore case when searching for expansions.
;; But copy the expansion verbatim.
(setq dabbrev-case-fold-search t)
(setq dabbrev-case-replace nil)

(defun find-user-init-file ()
  "Edit init.el in another window."
  (interactive)
  (find-file-other-window user-init-file))
(global-set-key (kbd "C-c I") 'find-user-init-file)

(setq show-paren-delay 0)
(show-paren-mode t)
(setq show-paren-style 'expression)

;; GUD configuration.
(gud-tooltip-mode)

;; Org configuration.
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c b") 'org-iswitchb)
