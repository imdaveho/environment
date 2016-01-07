;; (add-hook 'after-init-hook 'origami-mode))
(global-set-key (kbd "C-S o") 
  (lambda ()
    (global-origami-mode))

(eval-after-load 'origami
  (lambda () 
    (add-to-list 'origami-parser-alist '(typescript-mode . origami-c-style-parser))
    (define-key origami-mode-map (kbd "C-o o") 'origami-show-node)
    (define-key origami-mode-map (kbd "C-o c") 'origami-close-node)
    (define-key origami-mode-map (kbd "C-o t") 'origami-recursively-toggle-node)
    (define-key origami-mode-map (kbd "C-o s") 'origami-show-node)
    (define-key origami-mode-map (kbd "C-o O") 'origami-open-all-nodes)
    (define-key origami-mode-map (kbd "C-o C") 'origami-close-all-nodes)
    (define-key origami-mode-map (kbd "C-o T") 'origami-toggle-all-nodes)
    (define-key origami-mode-map (kbd "C-o S") 'origami-show-onnly-node))

(provide 'init-origami)
