;; Set Window Size
(when window-system (set-frame-size (selected-frame) 120 46))

;; OSX stuff
(setq ns-pop-up-frames nil)
;;(setq ns-use-srgb-colorspace nil)

;; Display time in mode line
(display-time)

;; Kill GUI cruft
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(cond ((not window-system)
       (menu-bar-mode -1)))

;; No cursor blink
;; (blink-cursor-mode -1)

;; Line numbers
(global-linum-mode 1)
(column-number-mode 1)
(show-paren-mode 1)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Ref: https://gist.github.com/themattchan/112f4a71294aec281fa9
;; Fix Emacs interface annoyances
;; Settings for ALL buffers
(setq-default
 inhibit-splash-screen t
 inhibit-startup-message t
 inhibit-startup-screen t
 inhibit-startup-buffer-menu t
 initial-scratch-message ""
 menu-prompting nil
 confirm-kill-emacs 'y-or-n-p
 display-warning-minimum-level 'error
 disabled-command-function nil
 line-number-mode t
 column-number-mode t
 scrolling-preserve-screen-position t
 mouse-wheel-mode t
 echo-keystrokes 0.1
 redisplay-dont-pause t
 scroll-margin 1
 scroll-step 1
 scroll-conservatively 10000
 scroll-preserve-screen-position 1
 mouse-wheel-follow-mouse 't
 mouse-wheel-scroll-amount '(1 ((shift) . 1))
 save-place t
 save-place-forget-unreadable-files t
 uniquify-rationalize-file-buffer-names t
 uniquify-buffer-name-style 'forward
 buffers-menu-sort-function 'sort-buffers-menu-by-mode-then-alphabetically
 buffers-menu-submenus-for-groups-p t
 ibuffer-default-sorting-mode 'filename/process
 font-lock-use-fonts '(or (mono) (grayscale))
 font-lock-use-colors '(color)
 font-lock-maximum-decoration t
 font-lock-maximum-size nil
 font-lock-auto-fontify t
 ring-bell-function 'ignore
)

;; Set themes
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'zenburn t)

;; Smart Mode Line
(setq sml/theme 'dark)
(sml/setup)

(provide 'init-ui)
