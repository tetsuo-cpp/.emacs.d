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
  (global-set-key (kbd "C-s") 'swiper)
  (global-set-key (kbd "C-c C-r") 'ivy-resume)
  (global-set-key (kbd "<f6>") 'ivy-resume)
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "<f1> f") 'counsel-describe-function)
  (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
  (global-set-key (kbd "<f1> l") 'counsel-find-library)
  (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
  (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
  (global-set-key (kbd "C-c g") 'counsel-git)
  (global-set-key (kbd "C-c j") 'counsel-git-grep)
  (global-set-key (kbd "C-c k") 'counsel-ag)
  (global-set-key (kbd "C-x l") 'counsel-locate)
  (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
  :config
  (ivy-mode t))

;; Use Ivy for more things.
(use-package counsel)

;; Enhanced ISearch.
(use-package swiper)

;; Display what is bound to each key.
(use-package which-key
  :config
  (which-key-mode))

;; Bracket completion.
(use-package smartparens
  :config
  (require 'smartparens-config)
  (smartparens-global-mode t))

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
  :config
  (projectile-global-mode))

(use-package counsel-projectile
  :config
  (counsel-projectile-mode))

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
  :config
  (defun clang-format-buffer-smart ()
    "Reformat buffer if .clang-format exists in the projectile root."
    (interactive)
    (when (file-exists-p (expand-file-name ".clang-format" (projectile-project-root)))
      (clang-format-buffer)))
  (global-set-key (kbd "C-c f") 'clang-format-buffer-smart))

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
  :init
  (global-set-key (kbd "C-:") 'avy-goto-char)
  (global-set-key (kbd "C-'") 'avy-goto-char-2)
  (global-set-key (kbd "M-g f") 'avy-goto-line)
  (global-set-key (kbd "M-g w") 'avy-goto-word-1)
  (global-set-key (kbd "M-g e") 'avy-goto-word-0)
  :config
  (avy-setup-default))

(use-package rust-mode
  :init
  (setq rust-format-on-save t))

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

(use-package powerline
  :init
  (setq powerline-default-separator 'wave))

;; Use Moe dark theme.
(use-package moe-theme
  :init
  (setq moe-theme-highlight-buffer-id nil)
  :config
  (load-theme 'moe-dark t)
  (powerline-moe-theme)
  (moe-theme-set-color 'cyan))

;; Set default font.
(set-face-attribute 'default nil :font "Iosevka Term-13")

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
(setq cursor-type 'box)
(set-cursor-color "cyan")
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

(show-paren-mode t)
(setq show-paren-style 'expression)

;; GUD configuration.
(gud-tooltip-mode)
