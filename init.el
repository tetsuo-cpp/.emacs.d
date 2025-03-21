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

;; Bootstrap straight.
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Load secrets if they exist
(let ((secrets-file (expand-file-name "secrets.el" user-emacs-directory)))
  (when (file-exists-p secrets-file)
    (load secrets-file)))

;; Packages.
(use-package ac-dcd
  :disabled t
  :ensure t
  :pin melpa
  :hook (d-mode . ac-dcd-setup)
  :bind (("M-." . 'ac-dcd-goto-definition)
         ("M-," . 'ac-dcd-goto-def-pop-marker)))

(use-package aidermacs
  :ensure t
  :pin melpa
  :bind (("C-c a" . aidermacs-transient-menu))
  :config
  ;; Claude Sonnet 3.5
  ;; (setq aidermacs-default-model "anthropic/claude-3-5-sonnet-20241022")
  ;; (when (boundp 'aidermacs-anthropic-api-key)
  ;;   (setenv "ANTHROPIC_API_KEY" aidermacs-anthropic-api-key))

  ;; Hyperbolic DeepSeek V3
  (setq aidermacs-default-model "openai/deepseek-ai/DeepSeek-V3")
  (setenv "OPENAI_API_BASE" "https://api.hyperbolic.xyz/v1/")
  ;; Optional OpenAI key from secrets
  (when (boundp 'aidermacs-hyperbolic-api-key)
    (setenv "OPENAI_API_KEY" aidermacs-hyperbolic-api-key))

  (setq aidermacs-auto-commits t)
  ;; (setq aidermacs-use-architect-mode t)
  )

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
  (setq company-tooltip-align-annotations t)
  :config
  (setq lsp-completion-provider :capf))

(use-package company-lsp
  :disabled t
  :pin melpa
  :after lsp-mode
  :commands company-lsp)

(use-package compile
  :init
  (setq compilation-scroll-output t)
  :config
  (add-hook 'compilation-filter-hook 'ansi-color-compilation-filter))

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

(use-package eglot
  :ensure t
  :hook ((c++-mode  . eglot-ensure)
         (c-mode    . eglot-ensure)
         (rust-mode . eglot-ensure)
         (zig-mode  . eglot-ensure))
  :config
  (add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd"))
  (add-to-list 'eglot-server-programs '(zig-mode "zls")))

(use-package elfeed
  :ensure t
  :pin melpa
  :init
  (setq elfeed-feeds
        '("https://danluu.com/atom.xml"
          "https://wingolog.org/feed/atom"
          "https://blog.yossarian.net/feed.xml"
          "https://blog.llvm.org/index.xml"
          "https://blogs.igalia.com/compilers/feed/feed.xml"
          "https://blog.trailofbits.com/feed/"
          "https://kevin.burke.dev/feed/"
          "https://bernsteinbear.com/feed.xml"
          "https://lemire.me/blog/feed/"
          "https://drewdevault.com/blog/index.xml"
          "https://jvns.ca/atom.xml"
          "https://journal.stuffwithstuff.com/atom.xml"
          "http://antirez.com/rss"
          "https://blog.regehr.org/feed"
          "https://blog.acolyer.org/feed/"
          "https://ericlippert.com/feed/"
          "https://100r.co/links/rss.xml"
          "https://matklad.github.io/feed.xml"
          "https://rachelbythebay.com/w/atom.xml"
          "https://lukesmith.xyz/index.xml"
          "https://mtlynch.io/index.xml"
          "https://blog.jessfraz.com/index.xml"
          "https://aphyr.com/posts.atom"
          "https://nullprogram.com/feed/"
          "https://www.brendangregg.com/blog/rss.xml"
          "https://bcantrill.dtrace.org/feed/"
          "https://andrewkelley.me/rss.xml"
          "https://blog.sigplan.org/feed/"
          "https://shape-of-code.com/feed/"
          "https://notes.eatonphil.com/rss.xml"
          "https://steveklabnik.com/feed.xml"
          "https://jack-vanlightly.com/?format=rss"
          "https://smalldatum.blogspot.com/feeds/posts/default"
          "https://zserge.com/rss.xml"
          "https://ludic.mataroa.blog/rss/"
          "https://xeiaso.net/blog.rss"
          "https://fasterthanli.me/index.xml"
          "https://ridiculousfish.com/blog/atom.xml"
          "https://fabiensanglard.net/rss.xml"
          "https://randomascii.wordpress.com/feed/"
          "https://www.jeffgeerling.com/blog.xml"
          "https://eli.thegreenplace.net/feeds/all.atom.xml"
          "https://matt.might.net/articles/feed.rss"
          "https://austinhenley.com/blog/feed.rss"
          "https://briancallahan.net/blog/feed.xml"
          "https://maskray.me/blog/atom.xml"
          "https://www.mgaudet.ca/technical?format=rss"
          "https://www.mgaudet.ca/blog?format=rss"
          "https://goold.au/rss/"
          "https://borretti.me/feed.xml"
          "https://zmatt.net/feed/"
          "https://pointersgonewild.com/feed/"
          "https://writings.stephenwolfram.com/feed/"
          "https://daniel.haxx.se/blog/feed/"
          "https://nickselby.com/docs/index.xml"
          "https://xol.io/blah/index.xml"
          "https://mahaloz.re/feed.xml"
          "https://googleprojectzero.blogspot.com/feeds/posts/default"
          "https://thesiswhisperer.com/feed/"
          "https://sethmlarson.dev/feed"
          "https://chandlerc.blog/index.xml"
          "https://www.scattered-thoughts.net/atom.xml"
          "https://weliveindetail.github.io/blog/feed.xml"
          "https://dr-knz.net/feeds/all.rss.xml"
          "https://jeremykun.com/feed/"
          "https://sachachua.com/blog/feed/atom/"
          "https://karthinks.com/index.xml"
          "https://research.swtch.com/feed.atom"
          "https://kentosec.com/feed/"
          "https://www.nayuki.io/rss20.xml"
          "https://crnkovic.dev/rss/"
          "https://makslevental.github.io/feed.xml"
          "https://www.lei.chat/posts/index.xml"
          "https://andreyor.st/feed.xml"
          "https://kyju.org/blog/atom.xml"
          "https://pappasbrent.com/feed.xml"
          "https://neugierig.org/software/blog/atom.xml"
          "https://oscarhong.net/feed/"
          "https://www.douggregor.net/feed.rss"
          "https://izzys.casa/index.xml"
          "https://jesseduffield.com/feed.xml"
          "https://despairlabs.com/blog/index.xml"
          "https://blog.kevmod.com/feed/"
          "https://herecomesthemoon.net/posts/index.xml"
          "https://mcyoung.xyz/atom.xml"
          "https://ai-andy-gill.hashnode.dev/rss.xml"
          "https://marcelgarus.dev/rss"
          "https://irrationalanalysis.substack.com/feed"
          "https://charity.wtf/feed/"
          "https://farena.in/feed.xml"
          "https://tetsuo.sh/atom.xml")))

(use-package erc
  :bind ("C-c e f" . (lambda ()(interactive)
                       (erc-tls :server "bnc.irccloud.com"
                                :port "6697"
                                :nick "tetsuo-cpp"
                                :password erc-libera-password)
                       (erc-tls :server "bnc.irccloud.com"
                                :port "6697"
                                :nick "tetsuo-cpp"
                                :password erc-darkscience-password)
                       (erc-tls :server "bnc.irccloud.com"
                                :port "6697"
                                :nick "tetsuo-cpp"
                                :password erc-oftc-password)))
  ;; Map send line to C-c RET to avoid accidentally sending messages.
  :bind (:map erc-mode-map
              ("RET" . nil)
              ("C-c RET" . 'erc-send-current-line))
  :init
  (setq erc-interpret-mirc-color t)
  (setq erc-hide-list '("JOIN" "PART" "QUIT")))

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
  :hook ((scala-mode . lsp)
         (go-mode . lsp)
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

(use-package modus-themes
  :ensure t
  :pin melpa
  :bind (("C-c t" . 'modus-themes-toggle))
  :config
  (load-theme 'modus-operandi))

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

(use-package rainbow-delimiters
  :ensure t
  :pin melpa
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package rustic
  :ensure t
  :pin melpa
  :config
  (setq rustic-lsp-client 'eglot)
  :custom
  (rustic-analyzer-command '("rustup" "run" "stable" "rust-analyzer")))

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

(setq load-path
      (cons (expand-file-name (concat user-emacs-directory "llvm")) load-path))
(require 'llvm-mode)
(require 'mlir-mode)
