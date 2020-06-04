;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Dave Ho"
      user-mail-address "imdaveho@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Fira Code" :size 14)
      doom-unicode-font (font-spec :family "Noto Color Emoji" :size 14)
      doom-variable-pitch-font (font-spec :family "Noto Mono" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

;; User Config ================================================================

;; init
(setq default-directory "~/devel")
(add-to-list 'default-frame-alist '(height . 40))
(add-to-list 'default-frame-alist '(width . 100))

;; helm
;; (customize-set-variable 'helm-ff-lynx-style-map t)

;; rust
;; (setq lsp-rust-server 'rust-analyzer)
;; (setq lsp-rust-analyzer-server-command '("~/devel/usr/bin/rust-analyzer"))
(setq rustic-lsp-server 'rust-analyzer)
(defun add-rustic-clippy ()
  (push 'rustic-clippy flycheck-checkers))
(add-hook 'rustic-mode-local-vars-hook #'add-rustic-clippy)
(remove-hook 'rustic-mode-hook 'flycheck-mode)
;;
;; (defun rustic-checker ()
;;   (flycheck-select-checker 'rustic-clippy))
;; (add-hook 'rustic-mode-local-vars-hook #'lsp-deferred)
;; (add-hook 'rustic-mode-local-vars-hook #'rustic-checker)
