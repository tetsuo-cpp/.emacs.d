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
(use-package ac-dcd
  :disabled t
  :ensure t
  :pin melpa
  :hook (d-mode . ac-dcd-setup)
  :bind (("M-." . 'ac-dcd-goto-definition)
         ("M-," . 'ac-dcd-goto-def-pop-marker)))

(use-package avy
  :ensure t
  :pin melpa
  :bind (("C-c s" . 'avy-goto-line)
         ("C-c c" . 'avy-goto-char-timer))
  :config
  (avy-setup-default))

(use-package bison-mode
  :ensure t
  :pin melpa
  :mode ("\\.l\\'" "\\.y\\'" "\\.yy\\'" "\\.ypp\\'" "\\.y++\\'"))

(use-package blacken
  :ensure t
  :pin melpa
  :hook (python-mode . enable-blacken)
  :config
  (defun enable-blacken ()
    (interactive)
    "Enable Blacken Formatter"
    (local-set-key (kbd "C-c f") 'blacken-buffer)))

(use-package c
  :hook (c-mode . wiredtiger-c-setup)
  :preface
  (defun wiredtiger-c-setup ()
    (setq c-default-style "bsd"
          c-basic-offset 4)
    (c-set-offset 'substatement-open 0)
    (c-set-offset 'arglist-intro '+)))

(use-package c++
  :mode ("\\.h\\'" . c++-mode)
  :hook (c++-mode . optiver-cpp-setup)
  :preface
  (defun optiver-cpp-setup ()
    (setq c-default-style "linux"
          c-basic-offset 4
          tab-width 4)
    (c-set-offset 'innamespace 0)
    (c-set-offset 'substatement-open 0)
    (c-set-offset 'inline-open 0)))

(use-package ccls
  :ensure t
  :pin melpa
  :hook ((c-mode c++-mode objc-mode cuda-mode) .
         (lambda () (require 'ccls) (lsp))))

(use-package clang-format
  :ensure t
  :pin melpa
  :after projectile
  :hook ((c++-mode . enable-clang-format)
         (c-mode   . enable-clang-format))
  :config
  (defun projectile-clang-format ()
    (interactive)
    (when (file-exists-p
           (expand-file-name ".clang-format" (projectile-project-root)))
      (clang-format-buffer)))
  (defun enable-clang-format ()
    (interactive)
    "Enable Clang Format"
    (local-set-key (kbd "C-c f") 'projectile-clang-format)))

(use-package cmake-mode
  :ensure t
  :pin melpa)

(use-package common-lisp-snippets
  :ensure t
  :pin melpa)

(use-package company
  :ensure t
  :pin melpa
  :hook (scala-mode . company-mode)
  :init
  (setq company-tooltip-align-annotations t))

(use-package company-lsp
  :ensure t
  :pin melpa
  :after lsp-mode
  :commands company-lsp)

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

(use-package d-mode
  :ensure t
  :pin melpa)

(use-package dfmt
  :ensure t
  :pin melpa
  ;; Defaults don't match my C-c f convention.
  ;; :hook (d-mode-hook . dfmt-setup-keys)
  :hook (d-mode . enable-dfmt)
  :config
  (defun enable-dfmt ()
    (interactive)
    "Enable DFmt"
    (local-set-key (kbd "C-c f") 'dfmt-buffer)))

(use-package dockerfile-mode
  :ensure t
  :pin melpa
  :mode "Dockerfile\\'")

(use-package ef-themes
  :ensure t
  :pin melpa
  :bind (("C-c t" . 'toggle-themes))
  :init
  (setq tetsuo-dark-mode t)
  :config
  (defun toggle-themes ()
    (interactive)
    (mapc #'disable-theme custom-enabled-themes)
    ;; Can't figure out how to get `ef-themes-load-random' working
    (if tetsuo-dark-mode
        (progn
          (load-theme 'ef-spring)
          (setq tetsuo-dark-mode nil))
      (progn
        (load-theme 'ef-autumn)
        (setq tetsuo-dark-mode t)))
    )
  (toggle-themes)
  )

(use-package erc
  :bind ("C-c e f" . (lambda ()(interactive)
                       (erc :server "irc.freenode.net"
                            :port "6667"
                            :nick "tetsuo-cpp")))
  ;; Map send line to C-c RET to avoid accidentally sending messages.
  :bind (:map erc-mode-map
              ("RET" . nil)
              ("C-c RET" . 'erc-send-current-line))
  :init
  (setq erc-autojoin-channels-alist '(("freenode.net" "#emacs" "#zig")))
  (setq erc-interpret-mirc-color t))

(use-package eshell
  :init
  :hook (eshell-mode . (lambda ()
                         (add-to-list 'eshell-visual-commands "ssh")
                         (add-to-list 'eshell-visual-commands "less")
                         (add-to-list 'eshell-visual-commands "git")))
  :config
  (setq eshell-destroy-buffer-when-process-dies t)
  (eshell))

(use-package evil
  :ensure t
  :pin melpa)

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

;; Try using CCLS with LSP mode instead since I'll be mainly working on CMake projects.
(use-package ggtags
  :disabled t
  :ensure t
  :pin melpa
  :hook ((c++-mode . enable-ggtags)
         (c-mode   . enable-ggtags))
  :config
  (defun enable-ggtags ()
    "Enable GGTags."
    (ggtags-mode t))
  (setenv "PATH" (concat (getenv "PATH") ":/opt/homebrew/bin/"))
  (setenv "GTAGSFORCECPP" "1"))

(use-package github-review
  :ensure t
  :pin melpa)

(use-package go-mode
  :ensure t
  :pin melpa
  :hook (go-mode . enable-gofmt)
  :config
  (defun enable-gofmt ()
    (interactive)
    "Enable GoFmt"
    (local-set-key (kbd "C-c f") 'gofmt)))

(use-package go-snippets
  :ensure t
  :pin melpa)

;; (use-package gruvbox-theme
;;   :ensure t
;;   :pin melpa
;;   :config
;;   (load-theme 'gruvbox-dark-hard t))

(use-package gud
  :init
  (setq gdb-many-windows t)
  :config
  (gud-tooltip-mode))

(use-package inf-mongo
  :ensure t
  :pin melpa)

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

(use-package lsp-metals
  :ensure t
  :pin melpa)

(use-package lsp-mode
  :ensure t
  :pin melpa
  :hook ((zig-mode . lsp)
         (scala-mode . lsp)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp
  :config
  (add-to-list 'lsp-language-id-configuration '(zig-mode . "zig"))
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection "zls")
    :major-modes '(zig-mode)
    :server-id 'zls))
  (define-key lsp-mode-map (kbd "C-c l") lsp-command-map))

(use-package lsp-pyright
  :ensure t
  :pin melpa
  :after exec-path-from-shell
  :hook (python-mode . (lambda ()
			 (require 'lsp-pyright)
			 (lsp)))
  :init
  (setq lsp-pyright-venv-directory "env/"))

(use-package lsp-ui
  :ensure t
  :pin melpa
  :after company-lsp
  :commands lsp-ui-mode)

(use-package lua-mode
  :ensure t
  :pin melpa)

(use-package magit
  :ensure t
  :pin melpa
  :bind (("C-x g"   . 'magit-status)
         ("C-x M-g" . 'magit-dispatch-popup)))

(use-package mastodon
  :ensure t
  :pin melpa
  :init
  (setq mastodon-instance-url "https://infosec.exchange"
        mastodon-active-user "tetsuo_cpp"))

;; (use-package modus-themes
;;   :ensure t
;;   :pin melpa
;;   :bind (("C-c t" . 'modus-themes-toggle))
;;   :config
;;   (load-theme 'modus-operandi))

(use-package oberon
  :ensure t
  :pin melpa
  :init
  (add-to-list 'auto-mode-alist '("\\.Mod\\'" . oberon-mode))
  (autoload 'oberon-mode "oberon" nil t)
  (add-hook 'oberon-mode-hook (lambda () (abbrev-mode t))))

(use-package pomidor
  :ensure t
  :pin melpa
  :bind (("C-x p" . pomidor))
  ;; I don't want my Emacs to be noisy...
  :config (setq pomidor-sound-tick nil
                pomidor-sound-tack nil)
  :hook (pomidor-mode . (lambda ()
                          (setq left-fringe-width 0 right-fringe-width 0)
                          (setq left-margin-width 2 right-margin-width 0)
                          ;; Force fringe update.
                          (set-window-buffer nil (current-buffer)))))

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

(use-package racer
  :ensure t
  :pin melpa
  :hook ((rust-mode . racer-mode)
         (racer-mode . eldoc-mode)
         (racer-mode . company-mode))
  :bind (("TAB" . 'company-indent-or-complete-common)))

(use-package rainbow-delimiters
  :ensure t
  :pin melpa
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package rust-mode
  :ensure t
  :pin melpa
  :hook (rust-mode . enable-rustfmt)
  :config
  (defun enable-rustfmt ()
    (interactive)
    "Enable RustFmt"
    (local-set-key (kbd "C-c f") 'rust-format-buffer)))


;; Enable scala-mode for highlighting, indentation and motion commands
(use-package scala-mode
  :ensure t
  :pin melpa
  :interpreter ("scala" . scala-mode))

(use-package slime
  :ensure t
  :pin melpa
  :init
  (load (expand-file-name "~/.roswell/helper.el"))
  (setq inferior-lisp-program "ros -Q run")
  (setq slime-contribs '(common-lisp-snippets)))

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
  :mode ("\\.yml\\'" "\\.clang-format\\'" "\\.idl\\'"))

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

(use-package yasnippet-snippets
  :ensure t
  :pin melpa)

(use-package zig-mode
  :ensure t
  :pin melpa)

;; Settings.
(setq inhibit-startup-screen t)
(when (fboundp 'set-scroll-bar-mode)
  (scroll-bar-mode -1))
(menu-bar-mode -1)
(if (eq system-type 'darwin)
    (set-face-attribute 'default nil :font "Monaco:size=21")
  (set-face-attribute 'default nil :font "Deja Vu Sans Mono:size=20"))
(setq-default cursor-type 'box)
(set-cursor-color "red")
(blink-cursor-mode -1)
(global-hl-line-mode t)
(set-face-background hl-line-face "gray")
(set-face-foreground 'highlight nil)
(setq ring-bell-function 'ignore)
(column-number-mode)
(defalias 'yes-or-no-p 'y-or-n-p)

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
