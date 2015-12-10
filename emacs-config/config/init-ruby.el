(autoload 'enh-ruby-mode "enh-ruby-mode" "Major mode for ruby files" t)
(add-to-list 'auto-mode-alist '("\\.rb$" . enh-ruby-mode))
(add-to-list 'interpreter-mode-alist '("ruby" . enh-ruby-mode))

(add-hook 'enh-ruby-mode-hook
  (lambda ()
    (global-rbenv-mode)
    (rbenv-use-corresponding)))

(add-hook 'enh-ruby-mode-hook 'robe-mode)
(add-hook 'enh-ruby-mode-hook 'company-mode)

(eval-after-load 'company
  '(push 'company-robe company-backends))

(provide 'init-ruby)
