;; Cask and Pallet (Emacs Package Manager + Helper)
(require 'cask "~/.cask/cask.el")
(cask-initialize)
(require 'pallet)
(pallet-mode t)

;; Theme Common Lisp Settings (eg. from sml/setup)


;;

;; User Info
(setq user-full-name "Dave Ho"
      user-mail-address "imdaveho@gmail.com")

;; Load Configs
(let ((debug-on-error t)
      (gc-cons-threshold (* 1024 1024 512))
      (file-name-handler-alist nil)
      (config-directory (concat user-emacs-directory "config/")))
(eval-when-compile (require 'cl))

(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(autoload 'dired-x "dired-x")

;; Define custom Config for dotemacs
(defgroup dotemacs nil
    "Custom configuration for dotemacs."
    :group 'local)
(defcustom dotemacs-cache-directory (concat user-emacs-directory ".cache/")
  "The storage location for various persistent files."
  :group 'dotemacs)
(defcustom dotemacs-completion-engine
  'company
  "The completion engine to use."
  :type '(radio
	  (const :tag "company-mode" company)
	  (const :tag "auto-complete-mode" auto-complete))
  :group 'dotemacs)
(defcustom dotemacs-switch-engine
  'helm
  "The primary engine to use for narrowing and navigation."
  :type '(radio
	  (const :tag "helm" helm)
	  (const :tag "ido" ido)
	  (const :tag "ivy" ivy))
  :group 'dotemacs)
(defcustom dotemacs-pair-engine
  'emacs
  "The primary engine to use auto-paring and parens matching."
  :type '(radio
          (const :tag "emacs" emacs)
          (const :tag "smartparens" smartparens))
  :group 'dotemacs)

;; Stop littering everywhere with save files, put them somewhere
(setq backup-directory-alist '(("." . "~/.emacs-backups")))
(setq auto-save-default nil)

;; Setting packages
(cl-loop for file in (directory-files config-directory t)
         when (string-match "\\.el$" file)
         do (require (intern (file-name-base file)) file)))
