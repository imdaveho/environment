(add-hook 'html-mode-hook 'web-mode)

;; associate with other HTML extensions
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))

;; indentation
(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)

;; custom syntax highlighting

(provide 'init-web)
