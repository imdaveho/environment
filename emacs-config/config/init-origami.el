;; http://emacs.stackexchange.com/questions/3488/define-controlshift-keys-without-kbd
;; (global-set-key (kbd "C-x C-\S-o") 'origami-mode)
;; setting origami globally on init since rather than setting a key (just easier)
(global-origami-mode)

(add-hook 'origami-mode-hook
  (lambda ()
    (add-to-list 'origami-parser-alist '(typescript-mode . origami-c-style-parser))
    (define-key origami-mode-map (kbd "C-c C-c f") 'origami-recursively-toggle-node)
    (define-key origami-mode-map (kbd "C-c C-c a") 'origami-toggle-all-nodes)
    (define-key origami-mode-map (kbd "C-c C-c s") 'origami-show-only-node)
    (define-key origami-mode-map (kbd "C-c C-c o") 'origami-open-node)
    (define-key origami-mode-map (kbd "C-c C-c k") 'origami-close-node)))

(provide 'init-origami)
