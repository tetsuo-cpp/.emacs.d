(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives
      '(("gnu"   . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

;; Bootstrap config.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; Packages.
(use-package avy
  :ensure t
  :pin melpa
  :bind (("C-;" . 'avy-goto-line)
         ("C-'" . 'avy-goto-char-timer))
  :config
  (avy-setup-default))

(use-package bison-mode
  :ensure t
  :pin melpa)

(use-package c++
  :mode ("\\.h\\'" . c++-mode)
  :hook (c++-mode . optiver-cpp-setup)
  :preface
  (defun optiver-cpp-setup ()
    (setq c-default-style "linux")
    (setq c-basic-offset 4)
    (setq tab-width 4)
    (c-set-offset 'innamespace 0)
    (c-set-offset 'substatement-open 0)
    (c-set-offset 'inline-open 0)))

(use-package clang-format
  :ensure t
  :pin melpa
  :after projectile
  :bind (("C-c f" . 'projectile-clang-format))
  :preface
  (defun projectile-clang-format ()
    (interactive)
    (when (file-exists-p (expand-file-name ".clang-format" (projectile-project-root)))
      (clang-format-buffer))))

(use-package cmake-mode
  :ensure t
  :pin melpa)

(use-package compile
  :init
  (setq compilation-scroll-output t))

(use-package counsel
  :ensure t
  :pin melpa
  :after ivy
  :bind (("M-x"     . 'counsel-M-x)
         ("C-x C-f" . 'counsel-find-file)
         ("C-c g"   . 'counsel-git)
         ("C-c j"   . 'counsel-git-grep)
         ("C-c k"   . 'counsel-ag)
         ("C-x l"   . 'counsel-locate)))

(use-package counsel-projectile
  :ensure t
  :pin melpa
  :after (counsel projectile)
  :config
  (counsel-projectile-mode))

(use-package dockerfile-mode
  :ensure t
  :pin melpa
  :mode "Dockerfile\\'")

(use-package eshell
  :init
  :hook (eshell-mode . (lambda ()
                         (add-to-list 'eshell-visual-commands "ssh")
                         (add-to-list 'eshell-visual-commands "less")
                         (add-to-list 'eshell-visual-commands "git")))
  :config
  (setq eshell-destroy-buffer-when-process-dies t)
  (eshell))

(use-package geiser
  :ensure t
  :pin melpa
  :init
  (setq geiser-active-implementations '(guile racket)))

(use-package ggtags
  :ensure t
  :pin melpa
  :hook ((c++-mode . enable-ggtags)
         (c-mode   . enable-ggtags))
  :config
  (defun enable-ggtags ()
    "Enable GGTags."
    (ggtags-mode t)))

(use-package gud
  :init
  (setq gdb-many-windows t)
  :config
  (gud-tooltip-mode))

(use-package ivy
  :ensure t
  :pin melpa
  :init
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  :bind (("C-c C-r" . 'ivy-resume)
         ("C-x b"   . 'ivy-switch-buffer)
         ("C-x B"   . 'ivy-switch-buffer-other-window))
  :config
  (ivy-mode t))

(use-package magit
  :ensure t
  :pin melpa
  :bind (("C-x g"   . 'magit-status)
         ("C-x M-g" . 'magit-dispatch-popup)))

(use-package projectile
  :ensure t
  :pin melpa
  :after ivy
  :init
  (setq projectile-completion-system 'ivy)
  (setq projectile-use-git-grep t)
  (setq projectile-enable-caching t)
  :config
  (projectile-global-mode))

(use-package rainbow-delimiters
  :ensure t
  :pin melpa
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package rebecca-theme
  :ensure t
  :pin melpa)

(use-package smartparens
  :ensure t
  :pin melpa
  :config
  (require 'smartparens-config)
  (smartparens-global-mode t))

(use-package smart-tabs-mode
  :ensure t
  :pin melpa
  :config
  (smart-tabs-insinuate 'c++))

(use-package swiper
  :ensure t
  :pin melpa
  :after ivy
  :bind ("C-s" . 'swiper)
  :bind (:map swiper-map
              ("M-%" . 'swiper-query-replace)
              ("C-." . 'swiper-avy)))

(use-package tramp
  :config
  (setq tramp-remote-path
        (cons 'tramp-own-remote-path tramp-remote-path)))

(use-package wgrep
  :ensure t
  :pin melpa
  :init
  (setq wgrep-auto-save-buffer t))

(use-package which-key
  :ensure t
  :pin melpa
  :config
  (which-key-mode))

(use-package yaml-mode
  :ensure t
  :pin melpa
  :mode ("\\.yml\\'" "\\.clang-format\\'"))

(use-package yasnippet
  :ensure t
  :pin melpa
  :init
  (setq yas-indent-line 'auto)
  (setq yas-also-indent-first-line t)
  (setq yas-triggers-in-field t)
  :config
  (setq yas-snippets-dir (concat user-emacs-directory "snippets"))
  (yas-global-mode t))

;; Settings.
(setq inhibit-startup-screen t)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(set-face-attribute 'default nil :font "Deja Vu Sans Mono:size=19")
(set-cursor-color "red")
(blink-cursor-mode -1)
(global-hl-line-mode t)
(set-face-foreground 'highlight nil)
(setq ring-bell-function 'ignore)

(setq apropos-sort-by-scores t)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(windmove-default-keybindings)

(setq dabbrev-case-fold-search t)
(setq dabbrev-case-replace nil)

(setq show-paren-delay 0)
(setq show-paren-style 'expression)
(show-paren-mode t)

(require 'dired-x)

(setq-default indent-tabs-mode nil)

(defun find-user-init-file ()
  (interactive)
  (find-file-other-window user-init-file))
(global-set-key (kbd "C-c I") 'find-user-init-file)

(global-auto-revert-mode t)
(delete-selection-mode t)
