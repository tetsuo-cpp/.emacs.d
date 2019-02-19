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
  :bind (("C-c s" . 'avy-goto-line)
         ("C-c c" . 'avy-goto-char-timer))
  :config
  (avy-setup-default))

(use-package bison-mode
  :ensure t
  :pin melpa)

(use-package blacken
  :ensure t
  :pin melpa
  :hook (python-mode . blacken-mode))

(use-package c
  :mode ("\\.h\\'" . c-mode)
  :hook (c-mode . wiredtiger-c-setup)
  :preface
  (defun wiredtiger-c-setup ()
    (setq c-default-style "bsd"
          c-basic-offset 4
          tab-width 4)
    (c-set-offset 'substatement-open 0)
    (c-set-offset 'arglist-intro '+)))

(use-package c++
  :hook (c++-mode . optiver-cpp-setup)
  :preface
  (defun optiver-cpp-setup ()
    (setq c-default-style "linux"
          c-basic-offset 4
          tab-width 4)
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

(use-package exec-path-from-shell
  :ensure t
  :pin melpa
  :config
  (exec-path-from-shell-initialize))

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
    (ggtags-mode t))
  (setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin")))

(use-package gud
  :init
  (setq gdb-many-windows t)
  :config
  (gud-tooltip-mode))

(use-package ivy
  :ensure t
  :pin melpa
  :init
  (setq ivy-use-virtual-buffers t
        enable-recursive-minibuffers t)
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
  (setq projectile-completion-system 'ivy
        projectile-use-git-grep t
        projectile-enable-caching t
        projectile-keymap-prefix (kbd "C-c p"))
  :config
  (setq projectile-globally-ignored-file-suffixes
        (append '(".o"
                  ".bin"
                  ".pyc"
                  "~")
                projectile-globally-ignored-file-suffixes)
        projectile-globally-ignored-directories
        (append '("CMakeFiles/"
                  "build/")
                projectile-globally-ignored-directories))
  (projectile-mode))

(use-package protobuf-mode
  :ensure t
  :pin melpa)

(use-package rainbow-delimiters
  :ensure t
  :pin melpa
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package smartparens
  :ensure t
  :pin melpa
  :init
  (setq-default sp-escape-quotes-after-insert nil)
  :config
  (require 'smartparens-config)
  (smartparens-global-mode t))

(use-package smart-tabs-mode
  :ensure t
  :pin melpa
  :config
  (smart-tabs-insinuate 'c++)
  (smart-tabs-insinuate 'c))

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
  (setq yas-indent-line 'auto
        yas-also-indent-first-line t
        yas-triggers-in-field t)
  :config
  (setq yas-snippets-dir (concat user-emacs-directory "snippets"))
  (yas-global-mode t))

;; Settings.
(load-theme 'adwaita)
(setq inhibit-startup-screen t)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(if (eq system-type 'darwin)
    (set-face-attribute 'default nil :font "Monaco:size=21")
  (set-face-attribute 'default nil :font "Deja Vu Sans Mono:size=21"))
(setq-default cursor-type 'box)
(set-cursor-color "red")
(blink-cursor-mode -1)
(global-hl-line-mode t)
(set-face-background hl-line-face "gray")
(set-face-foreground 'highlight nil)
(setq ring-bell-function 'ignore)

(setq apropos-sort-by-scores t)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(windmove-default-keybindings)

(setq dabbrev-case-fold-search t
      dabbrev-case-replace nil)

(setq show-paren-delay 0
      show-paren-style 'expression)
(show-paren-mode t)

(require 'dired-x)

(setq-default indent-tabs-mode nil)

(defun find-user-init-file ()
  (interactive)
  (find-file-other-window user-init-file))
(global-set-key (kbd "C-c I") 'find-user-init-file)

(global-auto-revert-mode t)
(delete-selection-mode t)
