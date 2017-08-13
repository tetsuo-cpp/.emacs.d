(setq package-enable-at-startup nil) (package-initialize)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("melpa" . "http://melpa.org/packages/")))

;; Install use-package if not already there.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Bootstrap configuration.
(require 'use-package)
(setq use-package-always-ensure t)

;; Helm completion framework.
(use-package helm)
(require 'helm-config)

;; Display what is bound to each key.
(use-package which-key)
(which-key-mode)

;; Bracket completion.
(use-package smartparens)
(require 'smartparens-config)
(smartparens-global-mode t)

;; Indent with tabs and align with spaces.
(use-package smart-tabs-mode)
(smart-tabs-insinuate 'c 'c++)

;; Project navigation.
(use-package projectile)
(projectile-global-mode)

;; Enable ido mode for file and buffer switching.
(ido-mode 1)
(setq ido-everywhere t)
(setq ido-enable-flex-matching t)

;; Allow remote editing.
(require 'tramp)

;; Pick up environmental variables and aliases on the remote machine.
(add-to-list 'tramp-remote-path 'tramp-own-remote-path)

;; Enhanced directory traversal.
(require 'dired-x)

;; Fix indentation.
(setq c-default-style "linux"
      c-basic-offset 4
      indent-tabs-mode t)
(setq-default tab-width 4)

;; Use leuven theme.
(load-theme 'leuven t)

;; Set default font.
(set-face-attribute 'default nil :font "Deja Vu Sans Mono-11")

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

;; Use hippie-expand over dabbrev expansion.
(global-set-key [remap dabbrev-expand] 'hippie-expand)
