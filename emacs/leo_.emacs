;; Disable startup message
(setq inhibit-startup-message t)

;; Overwrite selected text
(delete-selection-mode t)

;; Set font (Mac OS X only)
;;(set-frame-font "Menlo 13")

;; Set default tab mode to spaces
(setq-default indent-tabs-mode nil)

;; Set Mac OS command key as the meta key
;; Disable option key
;; (setq mac-option-key-is-meta nil)
;; (setq mac-command-key-is-meta t)
;; (setq mac-command-modifier 'meta)
;; (setq mac-option-modifier nil)

;;Respond 'y' or 'n' instead of 'yes' or 'no'
(fset 'yes-or-no-p 'y-or-n-p)

;; Appearance
(load-theme 'monokai t)

;; Fixes line number display
(setq line-number-display-limit 2000000)
(setq line-number-display-limit-width 5000)

;; Uses UTF-8
(prefer-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)

;; Set standard indent to 2 rather than 4
(setq standard-indent 2)

;; Start in fullscreen
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Stop writing backup ('~') files
(setq make-backup-files nil)

;; Set C comments to // instead of /**/
(add-hook 'c-mode-hook (lambda () (setq comment-start "// "
                                        comment-end   "")))

;; Set C++ comments to //
(add-hook 'c++-mode-hook (lambda () (setq comment-start "// "
                                          comment-end   "")))

;; Set CUDA comments to //
(add-hook 'cuda-mode-hook (lambda () (setq comment-start "// "
                                           comment-end   "")))

;; Use C++ mode for .C and .ci files
(add-to-list 'auto-mode-alist '("\\.C\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.ci\\'" . c++-mode))

;; Set CUDA mode
(add-to-list 'load-path "~/Library/emacs")
(autoload 'cuda-mode "cuda-mode.el")
(add-to-list 'auto-mode-alist '("\\.cu\\'" . cuda-mode))

;; .ccl files (ETK)
(add-to-list 'load-path "/home/leo/.emacs.d/modes")
(require 'ccl-mode)
(setq auto-mode-alist (append auto-mode-alist
                      (list '("\\.ccl$" . ccl-mode))))
(setq ccl-auto-newline t)

;;(add-hook 'prog-mode-hook #'auto-fill-mode)
(setq-default fill-column 80)

(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(monokai-theme sed-mode auctex markdown-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Delete trailing whitespace when saving a file
(add-hook 'before-save-hook 'my-prog-nuke-trailing-whitespace)

(defun my-prog-nuke-trailing-whitespace ()
  (when (derived-mode-p 'prog-mode)
    (delete-trailing-whitespace)))

(defun my-prog-nuke-trailing-whitespace ()
  (when (derived-mode-p 'cuda-mode)
    (delete-trailing-whitespace)))

;; Use F9 for align-regex
(global-set-key [f9] 'align-regexp)

;; Use F12 to comment line (useful when ESC=META)
(global-set-key [f12] 'comment-line)

;; Use Ctrl-/ to comment line
(global-set-key (kbd "C-/") 'comment-line)
