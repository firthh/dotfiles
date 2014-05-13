(setq exec-path (cons "/usr/local/bin/sml" exec-path))

;; Fix the PATH variable
(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (shell-command-to-string "$SHELL -i -c 'echo $PATH'")))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(when window-system (set-exec-path-from-shell-PATH))

(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))
(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/nyan-mode")
(load "nyan-mode.el")
(require 'rainbow-delimiters)

(defun hl-line-toggle-when-idle (&optional arg)
    "Turn on or off using `global-hl-line-mode' when Emacs is idle.
    When on, use `global-hl-line-mode' whenever Emacs is idle.
    With prefix argument, turn on if ARG > 0; else turn off."
      (interactive "P")
      (setq hl-line-when-idle-p
            (if arg (> (prefix-numeric-value arg) 0) (not hl-line-when-idle-p)))
      (cond (hl-line-when-idle-p
             (timer-activate-when-idle hl-line-idle-timer)
             (message "Turned ON using `global-hl-line-mode' when Emacs is idle."))
            (t
             (cancel-timer hl-line-idle-timer)
             (message "Turned OFF using `global-hl-line-mode' when Emacs is idle."))))
(global-hl-line-mode)

;; PLUGINS

;; Line numbers
 (global-linum-mode t)

;; Classic Rainbow
;; (custom-set-variables '(hl-paren-colors (quote ("orange" "yellow" "greenyellow" "green" "springgreen" "cyan" "slateblue" "magenta" "purple"))))
;; Eighties Rainbow
;; (custom-set-variables '(hl-paren-colors (quote ("#f2777a" "#f99157" "#ffcc66" "#99cc99" "#009999" "#99cccc" "#cc99cc"))))
;; Night Rainbow
;; (custom-set-variables '(hl-paren-colors (quote ("#cc6666" "#de935f" "#f0c674" "#b5bd68" "#8abeb7" "#81a2be" "#b294bb"))))
;; Bright Rainbow


;;(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
;; '(auto-save-default nil)
;; '(backup-inhibited t t)
;; '(column-number-mode t)
;; '(delete-selection-mode t)
;; '(inhibit-startup-screen t)
;; '(initial-scratch-message nil)
;; '(tool-bar-mode nil)
;; '(scroll-bar-mode nil))

(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(global-rainbow-delimiters-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector (vector "#708183" "#c60007" "#728a05" "#a57705" "#2075c7" "#c61b6e" "#259185" "#042028"))
 '(custom-enabled-themes (quote (sanityinc-solarized-dark)))
 '(custom-safe-themes (quote ("4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4" "4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" default)))
 '(fci-rule-color "#0a2832")
 '(markdown-command "/usr/local/bin/markdown")
 '(nrepl-history-file "~/.nreplhistory")
 '(nrepl-popup-on-error t)
 '(nrepl-popup-stacktraces t)
 '(nrepl-popup-stacktraces-in-repl t)
 '(nyan-animate-nyancat t)
 '(nyan-mode t)
 '(nyan-wavy-trail t)
 '(tool-bar-mode nil)
 '(vc-annotate-background nil)
 '(vc-annotate-color-map (quote ((20 . "#c60007") (40 . "#bd3612") (60 . "#a57705") (80 . "#728a05") (100 . "#259185") (120 . "#2075c7") (140 . "#c61b6e") (160 . "#5859b7") (180 . "#c60007") (200 . "#bd3612") (220 . "#a57705") (240 . "#728a05") (260 . "#259185") (280 . "#2075c7") (300 . "#c61b6e") (320 . "#5859b7") (340 . "#c60007") (360 . "#bd3612"))))
 '(vc-annotate-very-old-color nil)
 '(whitespace-style (quote (face tabs trailing lines space-before-tab empty space-after-tab tab-mark)))
 '(writeroom-width 120))

(setq my-onlinep nil)
(unless
    (condition-case nil
        (delete-process
         (make-network-process
          :name "my-check-internet"
          :host "elpa.gnu.org"
          :service 80))
      (error t))
  (setq my-onlinep t))

(setq my-packages
      '(paredit
	yaml-mode
	smart-tab
	textmate
        cider
        color-theme-sanityinc-solarized
        git-gutter-fringe))

(when my-onlinep
  (package-refresh-contents)
  (dolist (p my-packages nil)
    (unless (package-installed-p p)
      (package-install p))))


;;(color-theme-solarized-dark)

;; GIT gutter
(require 'git-gutter-fringe)
(global-git-gutter-mode t)


;; Super Tab
(require 'smart-tab)
(global-smart-tab-mode 1)

;; Paredit
(paredit-mode)

;; Show parens
(show-paren-mode)

(add-hook 'clojure-mode-hook 'highlight-parentheses-mode)
(add-hook 'clojure-mode-hook 'paredit-mode)
(add-hook 'clojure-mode-hook 'whitespace-mode)

(add-hook 'text-mode-hook 'column-number-mode)

(add-hook 'org-mode-hook 'visual-line-mode)

;; Textmate mode
(require 'textmate)
(textmate-mode)

(setq-default indent-tabs-mode nil)
(setq tab-width 2)
(setq-default truncate-lines t)

(font-lock-add-keywords 'clojure-mode
                        '(("(\\|)" . 'esk-paren-face)))
