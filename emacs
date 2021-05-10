(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(display-line-numbers nil)
 '(frame-background-mode 'dark)
 '(fzf/args
   "-x --color=dark --print-query --margin=1,0 --no-hscroll --info=hidden")
 '(lsp-ui-doc-enable nil)
 '(ns-alternate-modifier 'super)
 '(ns-command-modifier 'meta)
 '(package-archives
   '(("gnu" . "https://elpa.gnu.org/packages/")
     ("melpa" . "https://melpa.org/packages/")
     ("melpa-stable" . "https://stable.melpa.org/packages/")))
 '(package-selected-packages
   '(which-key fzf lsp-ui magit helm-projectile helm company projectile flycheck ace-window))
 '(safe-local-variable-values '((whitespace-line-column . 80)))
 '(size-indication-mode t)
 '(tool-bar-mode nil)
 '(which-key-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "black" :foreground "gray90" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "nil" :family "Menlo")))))

;;
;; Correct the exec-path and PATH to match what we would have in a shell.
;;
(defun set-exec-path-from-shell-PATH ()
  "Set up Emacs' `exec-path' and PATH environment variable to match
that used by the user's shell.

This is particularly useful under Mac OS X and macOS, where GUI
apps are not started from a shell."
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string
			  "[ \t\n]*$" "" (shell-command-to-string
					  "$SHELL --login -c 'echo $PATH'"
						    ))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(set-exec-path-from-shell-PATH)

;;
;; Set up use-package
;;
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(setq use-package-always-ensure t)

;;
;; ace-window mode (better window-switching)
;;
(use-package ace-window)
(global-set-key (kbd "M-o") 'ace-window)

;;
;; Flycheck
;;
(use-package flycheck
  :init
  (setq flycheck-ruby-rubocop-executable "bundle exec rubocop")
  (setq flycheck-ruby-executable (expand-file-name "~/.rbenv/shims/ruby"))

  :config
  (setq-default flycheck-disabled-checkers
                (append flycheck-disabled-checkers
                        '(ruby-rubylint)
                        '(emacs-lisp-checkdoc)))

  (global-flycheck-mode))

;; TODO: clangd (LSP?)

;;
;; Projectile ("projects" in emacs)
;;
(use-package projectile
  :init
  (setq projectile-indexing-method 'alien)
  (setq projectile-use-git-grep t)
  (setq projectile-tags-command "/usr/local/bin/ctags --exclude=node_modules --exclude=admin --exclude=.git --exclude=frontend --exclude=home --exclude=**/*.js -Re -f \"%s\" %s")

  :config
  (projectile-mode))

;;
;; ruby-mode
;;
(use-package ruby-mode
  :config
  (defun my-ruby-mode-hook ()
    (set-fill-column 80)
    (add-hook 'before-save-hook 'delete-trailing-whitespace nil 'local)
    (setq ruby-insert-encoding-magic-comment nil))
  (add-hook 'ruby-mode-hook 'my-ruby-mode-hook))

;;
;; LSP support
;;
(use-package lsp)
(use-package lsp-mode :commands lsp)
(use-package lsp-ui :commands lsp-ui-mode)
(use-package company-lsp :commands company-lsp)
(add-hook 'ruby-mode-hook #'lsp)
(add-hook 'enh-ruby-mode-hook #'lsp)
(setq lsp-prefer-flymake :none)
(setq lsp-log-io t)
(setq lsp-enable-snippet nil)

;;
;; company-mode (completion)
;;
(use-package company
  :config (global-company-mode))

;;
;; helm (selection narrowing)
;;
(use-package helm
  :bind (("M-x" . helm-M-x))
  :config
  (require 'helm-config)
  (helm-mode 1))

;;
;; helm-projectile (helm search within projects)
;;
(use-package helm-projectile
  :init
  (setq helm-projectile-fuzzy-match nil)

  :config
  (helm-projectile-on))

;;
;; magit (Git frontend)
;;
(use-package magit
  :bind (("C-c m s" . magit-status)))

;;
;; Local customizations.
;;
(if (file-exists-p "~/.emacs.local")
    (load "~/.emacs.local"))
