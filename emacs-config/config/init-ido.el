;; Completion modes, etc.
(defalias 'list-buffers 'ibuffer)
(autoload 'ido "ido")
(ido-mode t)
(ido-everywhere 1)
(setq ido-enable-flex-matching t
      ido-use-virtual-buffers t
      ido-use-faces nil)
(provide 'init-ido)
