(add-hook 'typescript-mode-hook
  (lambda ()
    (tide-setup)
    (company-mode-on)))

(provide 'init-typescript)
