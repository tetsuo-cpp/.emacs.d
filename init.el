;;; init.el --- Main configuration -*- lexical-binding: t; -*-

;;;; Package setup

(require 'package)
(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))
(setq package-check-signature nil)
(package-initialize)

(setq use-package-always-ensure t)

;;;; macOS environment

;; Inherit shell PATH on macOS (terminal Emacs launched from GUI may miss it).
(use-package exec-path-from-shell
  :if (eq system-type 'darwin)
  :config
  (exec-path-from-shell-initialize))

;;;; Minibuffer completion

;; Vertical completion UI.
(use-package vertico
  :init (vertico-mode))

;; Flexible matching (space-separated components match in any order).
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; Rich annotations in the minibuffer (docstrings, file sizes, etc.).
(use-package marginalia
  :init (marginalia-mode))

;; Searching and navigation commands.
(use-package consult
  :bind (("C-s"   . consult-line)
         ("C-x b" . consult-buffer)
         ("C-c g"  . consult-git-grep)
         ("C-c k"  . consult-ripgrep)
         ("C-c j"  . consult-git-grep)
         ("M-g g"  . consult-goto-line)
         ("M-g M-g" . consult-goto-line)))

;; Contextual actions on completion candidates.
(use-package embark
  :bind (("C-."   . embark-act)
         ("C-;"   . embark-dwim)
         ("C-h B" . embark-bindings)))

;; Integration between consult and embark.
(use-package embark-consult
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))

;;;; In-buffer completion

;; Lightweight completion popup using child frames (or terminal overlay).
(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  :init (global-corfu-mode))

;; Terminal support for corfu (child frames don't exist in terminal).
(use-package corfu-terminal
  :after corfu
  :config (corfu-terminal-mode +1))

;; Extra completion-at-point sources (dabbrev, file paths, etc.).
(use-package cape
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file))

;;;; Navigation & projects

;; Built-in project management.
(use-package project
  :ensure nil
  :bind-keymap ("C-c p" . project-prefix-map))

;; Jump to visible text quickly.
(use-package avy
  :bind (("C-c s" . avy-goto-line)
         ("C-c c" . avy-goto-char-timer))
  :config (avy-setup-default))

;; Edit grep results in-place.
(use-package wgrep
  :custom (wgrep-auto-save-buffer t))

;;;; Development — LSP (built-in eglot)

(use-package eglot
  :ensure nil
  :hook ((c-mode     . eglot-ensure)
         (c++-mode   . eglot-ensure)
         (c-ts-mode  . eglot-ensure)
         (c++-ts-mode . eglot-ensure)
         (rust-mode  . eglot-ensure)
         (rust-ts-mode . eglot-ensure)
         (zig-mode   . eglot-ensure)
         (python-mode . eglot-ensure)
         (python-ts-mode . eglot-ensure)
         (go-mode    . eglot-ensure)
         (go-ts-mode . eglot-ensure))
  :config
  (add-to-list 'eglot-server-programs '((c++-mode c-mode c++-ts-mode c-ts-mode) "clangd"))
  (add-to-list 'eglot-server-programs '((zig-mode) "zls"))
  (add-to-list 'eglot-server-programs '((python-mode python-ts-mode) "pyright-langserver" "--stdio"))
  (add-to-list 'eglot-server-programs '((go-mode go-ts-mode) "gopls")))

;;;; Development — tree-sitter

;; Automatic tree-sitter grammar installation and mode remapping.
(use-package treesit-auto
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;;;; Development — formatting

;; Universal async formatter — supports clang-format, black, gofmt,
;; rustfmt, zig fmt, and many more out of the box.
(use-package apheleia
  :bind ("C-c f" . apheleia-format-buffer)
  :config (apheleia-global-mode))

;;;; Development — compilation, debugging, parens

(use-package compile
  :ensure nil
  :custom (compilation-scroll-output t)
  :config
  (add-hook 'compilation-filter-hook #'ansi-color-compilation-filter))

(use-package gud
  :ensure nil
  :custom (gdb-many-windows t)
  :config (gud-tooltip-mode))

;; Built-in electric pair.
(electric-pair-mode t)

;;;; Languages — C/C++

(use-package c-ts-mode
  :ensure nil
  :hook (c-ts-mode . my/c-setup)
  :preface
  (defun my/c-setup ()
    (setq c-ts-mode-indent-offset 4)))

(use-package c++-ts-mode
  :ensure nil
  :mode "\\.h\\'"
  :hook (c++-ts-mode . my/cpp-setup)
  :preface
  (defun my/cpp-setup ()
    (setq c-ts-mode-indent-offset 4)))

;;;; Languages — Rust

(use-package rustic
  :custom (rustic-lsp-client 'eglot))

;;;; Languages — Zig

(use-package zig-mode)

;;;; Languages — Python (eglot + pyright, formatting via apheleia/black)

;;;; Languages — Go (eglot + gopls, formatting via apheleia/gofmt)

(use-package go-mode)

;;;; Languages — Protobuf

(use-package protobuf-mode)

;;;; Languages — CMake

(use-package cmake-mode)

;;;; Languages — Dockerfiles

(use-package dockerfile-mode
  :mode "Dockerfile\\'")

;;;; Languages — YAML

(use-package yaml-mode
  :mode ("\\.yml\\'" "\\.clang-format\\'" "\\.idl\\'"))

;;;; Languages — Markdown

(use-package markdown-mode
  :mode (("\\.md\\'" . gfm-mode))
  :custom
  (markdown-command "pandoc -f gfm --standalone --highlight-style=pygments"))

(use-package markdown-preview-mode
  :after markdown-mode
  :custom
  (markdown-preview-stylesheets
   '("https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.1.0/github-markdown.min.css"
     "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.8.0/styles/github.min.css")))

;;;; Languages — LLVM/MLIR (local modes)

(add-to-list 'load-path (expand-file-name "llvm" user-emacs-directory))
(require 'llvm-mode)
(require 'mlir-mode)

;;;; Git

(use-package magit
  :bind ("C-x g" . magit-status))

;;;; RSS (elfeed)

;; Feed reader — feed list lives in feeds.org via elfeed-org.
(use-package elfeed
  :bind ("C-c e" . elfeed))

(use-package elfeed-org
  :after elfeed
  :config
  (elfeed-org)
  (setq rmh-elfeed-org-files
        (list (expand-file-name "feeds.org" user-emacs-directory))))

;;;; UI & appearance

;; Built-in theme (ships with Emacs 28+).
(use-package modus-themes
  :ensure nil
  :bind ("C-c t" . modus-themes-toggle)
  :init (load-theme 'modus-operandi t))

;; Rainbow parentheses in programming modes.
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Show available keybinding continuations (built-in in Emacs 30).
(use-package which-key
  :ensure nil
  :config (which-key-mode))

;;;; Miscellaneous settings

;; Eshell.
(use-package eshell
  :ensure nil
  :hook (eshell-mode . (lambda ()
                         (add-to-list 'eshell-visual-commands "ssh")
                         (add-to-list 'eshell-visual-commands "less")
                         (add-to-list 'eshell-visual-commands "git")))
  :custom (eshell-destroy-buffer-when-process-dies t))

;; Tramp — use remote PATH.
(use-package tramp
  :ensure nil
  :config
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))

;; Dired extras.
(require 'dired-x)

;; Editor defaults.
(setq inhibit-startup-screen t)
(global-hl-line-mode t)
(set-face-foreground 'highlight nil)
(setq ring-bell-function #'ignore)
(column-number-mode)
(setq use-short-answers t)

(setq apropos-sort-by-scores t)
(add-hook 'before-save-hook #'delete-trailing-whitespace)
(windmove-default-keybindings)

(setq dabbrev-case-fold-search t
      dabbrev-case-replace nil)

(setq show-paren-delay 0
      show-paren-style 'expression)
(show-paren-mode t)

(setq-default indent-tabs-mode nil)

(global-auto-revert-mode t)
(delete-selection-mode t)

;; Quick access to this config file.
(defun find-user-init-file ()
  "Open init.el in another window."
  (interactive)
  (find-file-other-window user-init-file))
(global-set-key (kbd "C-c I") #'find-user-init-file)

;;; init.el ends here
