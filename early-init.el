;;; early-init.el --- Early initialisation -*- lexical-binding: t; -*-

;; Increase GC threshold during startup for faster loading.
(setq gc-cons-threshold (* 50 1024 1024))
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 8 1024 1024))))

;; Package.el is initialised in init.el via use-package.
(setq package-enable-at-startup nil)

;; Disable menu bar early (before any frame is created).
(push '(menu-bar-lines . 0) default-frame-alist)

;; Native compilation settings.
(setq native-comp-async-report-warnings-errors 'silent)

;;; early-init.el ends here
