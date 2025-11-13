;; -*- lexical-binding: t -*-

(use-package compat)

(use-package transient)

(setq dracula-background           "#282A36"
      dracula-foreground           "#F8F8F2"
      dracula-selection            "#44475A"
      dracula-comment              "#6272A4"
      dracula-red                  "#FF5555"
      dracula-orange               "#FFB86C"
      dracula-yellow               "#F1FA8C"
      dracula-green                "#50FA7B"
      dracula-purple               "#BD93F9"
      dracula-cyan                 "#8BE9FD"
      dracula-pink                 "#FF79C6"
      dracula-ansi-black           "#21222C"
      dracula-ansi-red             dracula-red
      dracula-ansi-green           dracula-green
      dracula-ansi-yellow          dracula-yellow
      dracula-ansi-blue            dracula-purple
      dracula-ansi-magenta         dracula-pink
      dracula-ansi-cyan            dracula-cyan
      dracula-ansi-white           dracula-foreground
      dracula-ansi-bright-black    dracula-comment
      dracula-ansi-bright-red      "#FF6E6E"
      dracula-ansi-bright-green    "#69FF94"
      dracula-ansi-bright-yellow   "#FFFFA5"
      dracula-ansi-bright-blue     "#D6ACFF"
      dracula-ansi-bright-magenta  "#FF92DF"
      dracula-ansi-bright-cyan     "#A4FFFF"
      dracula-ansi-bright-white    "#FFFFFF")

(use-package doom-themes
  :after eshell-git-prompt
  :config

  (defun jp/load-theme (&rest _)
    (when (display-graphic-p)
      (setq doom-dracula-padded-modeline t)
      (load-theme 'doom-dracula t)
      (doom-themes-visual-bell-config)
      (doom-themes-org-config)

      (require 'ansi-color)

      ;; Setup ANSI colors
      (set-face-attribute 'ansi-color-black
                          nil
                          :foreground dracula-ansi-black
                          :background dracula-ansi-black)
      
      (set-face-attribute 'ansi-color-red
                          nil
                          :foreground dracula-ansi-red
                          :background dracula-ansi-red)
      
      (set-face-attribute 'ansi-color-green
                          nil
                          :foreground dracula-ansi-green
                          :background dracula-ansi-green)
      
      (set-face-attribute 'ansi-color-yellow
                          nil
                          :foreground dracula-ansi-yellow
                          :background dracula-ansi-yellow)
      
      (set-face-attribute 'ansi-color-blue
                          nil
                          :foreground dracula-ansi-blue
                          :background dracula-ansi-blue)
      
      (set-face-attribute 'ansi-color-magenta
                          nil
                          :foreground dracula-ansi-magenta
                          :background dracula-ansi-magenta)
      
      (set-face-attribute 'ansi-color-cyan
                          nil
                          :foreground dracula-ansi-cyan
                          :background dracula-ansi-cyan)
      
      (set-face-attribute 'ansi-color-white
                          nil
                          :foreground dracula-ansi-white
                          :background dracula-ansi-white)
      
      (set-face-attribute 'ansi-color-bright-black
                          nil
                          :foreground dracula-ansi-bright-black
                          :background dracula-ansi-bright-black)
      
      (set-face-attribute 'ansi-color-bright-red
                          nil
                          :foreground dracula-ansi-bright-red
                          :background dracula-ansi-bright-red)
      
      (set-face-attribute 'ansi-color-bright-green
                          nil
                          :foreground dracula-ansi-bright-green
                          :background dracula-ansi-bright-green)
      
      (set-face-attribute 'ansi-color-bright-yellow
                          nil
                          :foreground dracula-ansi-bright-yellow
                          :background dracula-ansi-bright-yellow)
      
      (set-face-attribute 'ansi-color-bright-blue
                          nil
                          :foreground dracula-ansi-bright-blue
                          :background dracula-ansi-bright-blue)
      
      (set-face-attribute 'ansi-color-bright-magenta
                          nil
                          :foreground dracula-ansi-bright-magenta
                          :background dracula-ansi-bright-magenta)
      
      (set-face-attribute 'ansi-color-bright-cyan
                          nil
                          :foreground dracula-ansi-bright-cyan
                          :background dracula-ansi-bright-cyan)
      
      (set-face-attribute 'ansi-color-bright-white
                          nil
                          :foreground dracula-ansi-bright-white
                          :background dracula-ansi-bright-white)
      
      ;; Setup eshell colors
      (set-face-attribute 'eshell-git-prompt-exit-fail-face
                          nil
                          :foreground
                          dracula-red)
      (set-face-attribute 'eshell-git-prompt-exit-success-face
                          nil
                          :foreground
                          dracula-green)
      (set-face-attribute 'eshell-git-prompt-modified-face
                          nil
                          :foreground
                          dracula-pink)
      (set-face-attribute 'eshell-git-prompt-multiline2-command-face
                          nil
                          :foreground
                          dracula-foreground)
      (set-face-attribute 'eshell-git-prompt-multiline2-dir-face
                          nil
                          :foreground
                          dracula-yellow)
      (set-face-attribute 'eshell-git-prompt-multiline2-fail-face
                          nil
                          :foreground
                          dracula-red)
      (set-face-attribute 'eshell-git-prompt-multiline2-git-face
                          nil
                          :foreground
                          dracula-green)
      (set-face-attribute 'eshell-git-prompt-multiline2-host-face
                          nil
                          :foreground
                          dracula-purple)
      (set-face-attribute 'eshell-git-prompt-multiline2-secondary-face
                          nil
                          :foreground
                          dracula-purple)
      
      (set-face-attribute 'eshell-git-prompt-multiline2-usr-face
                          nil
                          :foreground
                          dracula-purple)
      
      ;; EMMS
      (set-face-attribute 'emms-browser-album-face
                          nil
                          :foreground
                          dracula-purple)
      (set-face-attribute 'emms-browser-artist-face
                          nil
                          :foreground
                          dracula-pink)
      (set-face-attribute 'emms-browser-composer-face
                          nil
                          :foreground
                          dracula-pink)
      (set-face-attribute 'emms-browser-performer-face
                          nil
                          :foreground
                          dracula-pink)
      (set-face-attribute 'emms-browser-track-face
                          nil
                          :foreground
                          "#d4b8fb")
      (set-face-attribute 'emms-browser-year/genre-face
                          nil
                          :foreground
                          dracula-red)
      (set-face-attribute 'emms-metaplaylist-mode-current-face
                          nil
                          :foreground "#d4b8fb"
                          :inverse-video t)
      (set-face-attribute 'emms-metaplaylist-mode-face
                          nil
                          :foreground "#d4b8fb")
      (set-face-attribute 'emms-playlist-selected-face
                          nil
                          :foreground 'unspecified
                          :inverse-video t)
      (set-face-attribute 'emms-playlist-track-face
                          nil
                          :foreground
                          dracula-purple)
      
      ;; Org
      (require 'org-indent)

      (dolist (face '((org-level-1 . 1.2)
                      (org-level-2 . 1.1)
                      (org-level-3 . 1.05)
                      (org-level-4 . 1.0)
                      (org-level-5 . 1.0)
                      (org-level-6 . 1.0)
                      (org-level-7 . 1.0)
                      (org-level-8 . 1.0)))
        (set-face-attribute (car face) nil :font "Source Code Pro" :weight 'regular :height (cdr face)))
      
      (set-face-attribute 'org-drawer nil :inherit '(variable-pitch))
      (set-face-attribute 'org-property-value nil :inherit '(variable-pitch))
      (set-face-attribute 'org-code nil :inherit '(shadow variable-pitch))
      (set-face-attribute 'org-verbatim nil :inherit '(shadow variable-pitch))
      (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face variable-pitch))
      (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face variable-pitch))
      (set-face-attribute 'org-checkbox nil :inherit '(variable-pitch))
      (set-face-attribute 'org-block nil :inherit '(fixed-pitch))
      (set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))

      (when (daemonp)
        (remove-hook 'server-after-make-frame-hook #'jp/load-theme))))

  (if (daemonp)
      (add-hook 'server-after-make-frame-hook #'jp/load-theme 1)
    (jp/load-theme (selected-frame))))

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)

(use-package doom-modeline
  :after compat
  :init
  (doom-modeline-mode 1)
  :config
  (defun jp/s-truncate (len s &optional ellipsis)
    "Like `s-truncate' but
    - return S when LEN is nil
    - return empty string when len is shorter than ELLIPSIS"
    (declare (pure t) (side-effect-free t))
    (let ((ellipsis (or ellipsis "...")))
      (cond
       ((null len) s)
       ((< len (length ellipsis)) "")
       (t (s-truncate len s ellipsis)))))
  (display-time)
  :custom
  (doom-modeline-bar-width 8)
  (doom-modeline-height 48)
  (echo-keystrokes 0.01)
  (display-time-default-load-average nil))

(defun jp/set-font-faces (frame)
  (with-selected-frame frame
    (set-face-attribute 'default nil
                        :font "FiraCode Nerd Font")
    (set-face-attribute 'fixed-pitch nil
                        :font "FiraCode Nerd Font")
    (set-face-attribute 'variable-pitch nil
                        :font "Source Code Pro")))

(if (daemonp)
    (add-hook 'after-make-frame-functions #'jp/set-font-faces 1)
  (jp/set-font-faces (selected-frame)))

(set-frame-parameter nil 'alpha-background 40)
(add-to-list 'default-frame-alist '(alpha-background . 60))

(set-frame-parameter nil 'inhibit-double-buffering t)
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))

(setq delete-by-moving-to-trash t)

(setq backup-directory-alist '(("." . "~/.emacs.d/backup")))
(setq backup-by-copying t)
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

(setq-default indent-tabs-mode nil)

(use-package emacs
  :ensure nil
  :init
  ;; Restore frame names
  (push '(name . nil) frameset-filter-alist)
  ;; Don't restore theme information
  (push '(foreground-color . :never) frameset-filter-alist)
  (push '(background-color . :never) frameset-filter-alist)
  (push '(font . :never) frameset-filter-alist)
  (push '(cursor-color . :never) frameset-filter-alist)
  (push '(background-mode . :never) frameset-filter-alist)
  (push '(ns-appearance . :never) frameset-filter-alist)
  (push '(background-mode . :never) frameset-filter-alist))

(setq help-window-select t)

(electric-indent-mode -1)

(setq window-sides-vertical t)

(use-package gcmh
  :demand
  :hook
  (focus-out . gcmh-idle-garbage-collect)
  :custom
  (setq gcmh-idle-delay 10)
  (setq gcmh-high-cons-threshold 104857600)
  :config
  (gcmh-mode +1))

(setq jit-lock-stealth-time 1.25)
(setq jit-lock-stealth-nice 0.5) ;; Seconds between font locking.
(setq jit-lock-chunk-size 4096)
(setq jit-lock-defer-time 0)
(with-eval-after-load 'evil
  (add-hook 'evil-insert-state-entry-hook 
            (lambda ()
              (setq jit-lock-defer-time 0.25)) nil t)
  (add-hook 'evil-insert-state-exit-hook 
            (lambda ()
              (setq jit-lock-defer-time 0)) nil t))

(setq native-comp-speed 3)

(setq inhibit-startup-screen t)

(blink-cursor-mode 0)

(setq visible-bell nil)

(set-fringe-mode 10)

(use-package unicode-fonts
  :config
  (unicode-fonts-setup))

(setq echo-keystrokes 0.01)

(column-number-mode)

(setq display-line-numbers-type 'relative)
(setq-default display-line-numbers-width 5)

(use-package emacs
  :ensure nil
  :after doom-themes
  :config
  (require 'hl-line)
  
  (defun jp/setup-hl-line (&rest _)
    (set-face-attribute 'hl-line nil :background dracula-selection)
    (set-face-attribute 'region nil :inverse-video t))
  
  (add-hook 'window-configuration-change-hook #'jp/setup-hl-line)
  (global-hl-line-mode 1)
  
  (defun jp/enable-hl-line (&rest _)
    (setq-local global-hl-line-mode t)
    (global-hl-line-highlight))
  
  (defun jp/disable-hl-line (&rest _)
    (setq-local global-hl-line-mode nil)
    (global-hl-line-unhighlight))
  
  (add-hook 'eshell-mode-hook #'jp/disable-hl-line)
  (add-hook 'term-mode-hook #'jp/disable-hl-line)
  (add-hook 'vterm-mode-hook #'jp/disable-hl-line)
  (add-hook 'evil-symex-state-entry-hook #'jp/disable-hl-line)
  (add-hook 'evil-symex-state-exit-hook #'jp/enable-hl-line))

(use-package nerd-icons)

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package nerd-icons-ivy-rich
  :after ivy-rich
  :init
  (nerd-icons-ivy-rich-mode 1))

(use-package nerd-icons-completion
  :config
  (nerd-icons-completion-mode 1))

(use-package treemacs-nerd-icons
  :after treemacs
  :config
  (treemacs-load-theme "nerd-icons"))

(use-package paren
  :ensure nil
  :config
  (show-paren-mode +1)
  :custom
  (show-paren-delay 0))

(use-package rainbow-delimiters)

(use-package which-key
  :config
  (which-key-mode)
  :custom
  (which-key-idle-delay 0.5)
  (which-key-idle-secondary-delay 1.0)
  (which-key-allow-evil-operators t)
  (which-key-allow-imprecise-window-fit t)
  (which-key-compute-remaps t)
  (which-key-dont-use-unicode nil)
  (which-key-show-prefix 'top)
  (which-key-popup-type 'minibuffer))

(setq scroll-conservatively 101)

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1) ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-follow-mouse t)

(setq tab-always-indent 'complete)

(setq display-buffer-base-action
      '(display-buffer-reuse-window
        display-buffer-same-window))

(use-package shrface
  :custom
  (shrface-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(use-package shr-tag-pre-highlight
  :after shr
  :config
  (add-to-list 'shr-external-rendering-functions
               '(pre . shr-tag-pre-highlight))
  (when (version< emacs-version "26")
    (with-eval-after-load 'eww
      (advice-add
       'eww-display-html :around
       'eww-display-html--override-shr-external-rendering-functions))))

(setq focus-follows-mouse t)
(setq mouse-autoselect-window t)

(setq inhibit-default-init t)

(defcustom inline-image-background "#FFFFFF"
  "The color used as the default background for inline images.
When nil, use the default face background."
  :group 'org
  :type '(choice color (const nil)))

(defun create-image-with-background-color (args)
  "Specify background color of Org-mode inline image through modify `ARGS'."
  (let* ((file (car args))
         (type (cadr args))
         (data-p (caddr args))
         (props (cdddr args)))
    ;; Get this return result style from `create-image'.
    (append (list file type data-p)
            (list :background
                  (or inline-image-background (face-background 'default)))
            props)))

(advice-remove 'create-image #'create-image-with-background-color)
;(advice-add 'create-image :filter-args
;            #'create-image-with-background-color)

(require 'image)
(setq image-scaling-factor 1)

(use-package undo-tree
  :config
  (global-undo-tree-mode)
  (defadvice undo-tree-make-history-save-file-name
      (after undo-tree activate)
    (setq ad-return-value (concat ad-return-value ".gz")))
  :custom
  ;; Prevent undo tree files from polluting your git repo
  (undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
  ;; Automatically save undo tree history
  (undo-tree-auto-save-history t))

;; Leave minibuffer if active, otherwise defer to evil default
(defun evil-escape ()
  (interactive)
  (if (minibuffer-window-active-p (selected-window))
      (abort-minibuffers)
    (evil-force-normal-state)))

(use-package evil
  :config
  (evil-mode 1)
  :custom
  (evil-undo-system 'undo-tree)
  (evil-want-integration t)
  (evil-want-keybinding nil)
  (evil-want-C-u-scroll t)
  (evil-respect-visual-line-mode t)
  (evil-want-minibuffer t))

(defun jp/window-lines ()
  (/ (window-body-height nil t) (line-pixel-height)))

(defun jp/scroll-up-half ()
  (interactive)
  (evil-next-line (- (/ (jp/window-lines) 2))))

(defun jp/scroll-down-half ()
  (interactive)
  (evil-next-line (/ (jp/window-lines) 2)))

(defun jp/scroll-up-full ()
  (interactive)
  (evil-next-line (- (jp/window-lines))))

(defun jp/scroll-down-full ()
  (interactive)
  (evil-next-line (jp/window-lines)))

(use-package evil-collection
  :custom
  (evil-collection-setup-minibuffer t)
  :config
  (evil-collection-init))

(defun jp/nop () (interactive))

(defun jp/evil-esc ()
  (interactive)
  (or (eq evil-state 'normal)
      (if (eq evil-previous-state 'symex)
          (symex-mode-interface)
        (evil-normal-state))))

(use-package symex-core
  :ensure (
           :type git
           :host github
           :repo "drym-org/symex.el"
           :files ("symex-core/symex*.el")))

(use-package symex
  :after (symex-core)

  :ensure (
           :type git
           :host github
           :repo "drym-org/symex.el"
           :files ("symex/symex*.el"
                   "symex/doc/*.texi"
                   "symex/doc/figures"))

  :custom
  (symex-racket-modes '(racket-mode racket-repl-mode racket-hash-lang-mode))

  :config
  (symex-mode 1)

  (lithium-define-keys symex-editing-mode
    ;; Transpose default horizontal / vertical bindings
    (("h" symex-go-down)
     ("j" symex-go-forward)
     ("k" symex-go-backward)
     ("l" symex-go-up)
     ("H" symex-raise)
     ("J" symex-shift-forward)
     ("K" symex-shift-backward)
     ("L" symex-join-lines)
     ("C-j" symex-climb-branch)
     ("C-k" symex-descend-branch)
     ("s-j" symex-goto-highest)
     ("s-k" symex-goto-lowest)
     ;; Remain in symex mode if escape is pressed
     ("<escape>" jp/nop)
     ;; Use delete to exit instead
     ("<delete>" symex-escape-higher :exit)
     (":" evil-ex)))

  (set-face-attribute 'symex-highlight-face
                      nil
                      :background dracula-selection
                      :inherit '(unspecified)))

(use-package symex-ide
  :after (symex)
  :ensure (
           :type git
           :host github
           :repo "drym-org/symex.el"
           :files ("symex-ide/symex*.el"))
  :config
  (symex-ide-mode 1))

(use-package symex-evil
  :after (symex evil)
  :ensure (
           :type git
           :host github
           :repo "drym-org/symex.el"
           :files ("symex-evil/symex*.el"))
  :config
  (symex-evil-mode 1))

(use-package ivy
  :bind
  (:map ivy-minibuffer-map
        ("TAB" . ivy-alt-done)
        ("C-l" . ivy-alt-done)
        ("C-j" . ivy-next-line)
        ("C-k" . ivy-previous-line))
  (:map ivy-switch-buffer-map
        ("C-k" . ivy-previous-line)
        ("C-l" . ivy-done)
        ("C-d" . ivy-switch-buffer-kill))
  (:map ivy-reverse-i-search-map
        ("C-k" . ivy-previous-line)
        ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package counsel
  :after projectile
  :config
  (setq ivy-initial-inputs-alist nil)
                                        ;(setq counsel-find-file-ignore-regexp "\\(?:^[#.]\\)\\|\\(?:[#~]$\\)")
  (counsel-mode 1))

(use-package counsel-projectile
  :after counsel
  :after projectile
  :config
  (counsel-projectile-mode 1))

(use-package swiper
  :bind ("C-s" . swiper-thing-at-point))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(defun launch-process (program &rest args)
  (apply 'call-process program nil 0 nil args))

(defun launch-browser (arg)
  (interactive "sLaunch browser: ")
  (launch-process "icecat"
                  (string-join (list "https://duckduckgo.com/?q=" arg))))

(defun launch-shell ()
  (interactive)
  (eshell t))

(defun launch-chromium ()
  (interactive)
  (launch-process "chromium"))

(defun launch-discord ()
  (interactive)
  (launch-process "flatpak" "--user" "run" "dev.vencord.Vesktop"))

(defun launch-retroarch ()
  (interactive)
  (with-environment-variables (("WAYLAND_DISPLAY" ""))
    (launch-process "retroarch")))

(defun launch-lutris ()
  (interactive)
  (launch-process "lutris"))

(defun launch-bottles ()
  (interactive)
  (launch-process "flatpak" "run" "com.usebottles.bottles"))

(defun launch-steam ()
  (interactive)
  (with-environment-variables (("GDK_SCALE" "2"))
    (launch-process "steam")))

(defun launch-mpv (&rest uri)
  (interactive)
  (apply 'call-process "mpv" nil 0 nil uri))

(defun openrgb-bright ()
  (interactive)
  (call-process "openrgb" nil 0 nil
                "--profile"
                "/home/josh/.config/OpenRGB/Default.orp"))

(defun openrgb-dim ()
  (interactive)
  (call-process "openrgb" nil 0 nil
                "--profile"
                "/home/josh/.config/OpenRGB/Dimmed.orp"))

(defun jp/reboot ()
  (interactive)
  (call-process "reboot" nil 0 nil))

(defun jp/poweroff ()
  (interactive)
  (call-process "poweroff" nil 0 nil))

(require 'dired)
(setq dired-listing-switches "-agho --group-directories-first")

(use-package dired-open
  :custom
  (dired-open-extensions '(("png" . "iv")
                           ("mkv" . "mpv"))))

(require 'dired-x)
(setq dired-omit-files "^\\(?:\\..*\\|.*~\\)$")

(setq ls-lisp-UCA-like-collation nil)

(defun jp/configure-eshell ()
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)
  (evil-normalize-keymaps))

(use-package emacs
  :ensure nil
  :hook (eshell-first-time-mode . jp/configure-eshell)
  :custom
  (eshell-history-size 10000)
  (eshell-buffer-maximum-lines 10000)
  (eshell-hist-ignoredups t)
  (eshell-scroll-to-bottom-on-input t)
  :config
  (setf eshell-visual-commands '()))

(use-package eshell-git-prompt
  :config
  (eshell-git-prompt-use-theme 'multiline2))

(use-package emacs
  :ensure nil
  :hook
  (prog-mode . electric-indent-local-mode)
  (prog-mode . jp/visual-fill-87)
  (prog-mode . company-mode)
  (prog-mode . display-line-numbers-mode)
  (prog-mode . rainbow-delimiters-mode)
  ;;(prog-mode . flyspell-prog-mode)

  (racket-hash-lang-mode . electric-indent-local-mode)
  (racket-hash-lang-mode . jp/visual-fill-87)
  (racket-hash-lang-mode . company-mode)
  (racket-hash-lang-mode . display-line-numbers-mode)
  (racket-hash-lang-mode . rainbow-delimiters-mode)
  ;;(racket-hash-lang-mode . flyspell-prog-mode)
  )

(use-package ob-racket
  :ensure (:type git :host github :repo "hasu/emacs-ob-racket")
  :config
  (add-hook 'ob-racket-pre-runtime-library-load-hook
            #'ob-racket-raco-make-runtime-library))

(use-package org
  :after ob-racket
  :custom
  (org-ellipsis " ⇓")
  (org-hide-emphasis-markers t)
  (org-confirm-babel-evaluate nil)
  (org-startup-folded 'content)
  (org-clock-persist 'history)
  (org-src-preserve-indentation t)
  (org-display-remote-inline-images 'cache)
  (org-startup-indented t)
  (org-fontify-quote-and-verse-blocks t)
  
  :hook
  (org-mode . variable-pitch-mode)
  (org-mode . visual-line-mode)
  (org-mode . jp/visual-fill)
  (org-mode . org-bullets-mode)
  (org-mode . (lambda () (electric-indent-local-mode -1)))
  (org-mode . org-inline-anim-mode)
                                        ;(org-mode . flyspell-mode)
  
  :config
  ;; Persist clock
  (org-clock-persistence-insinuate)
  
  (defun org-link--open-emms (path _)
    (emms-play-url path))
  
  (org-link-set-parameters
   "emms"
   :follow #'org-link--open-emms)

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (C . t)
     (java . t)
     (racket . t)
     (shell . t)
     (makefile . t)))
  
  ;; Scale for LaTeX preview
  (setf (plist-get org-format-latex-options :scale) 4.0)
  
  ;; Consistent behaviour for Java backend
  (setq org-babel-default-header-args:java
        '((:dir . nil)
          (:results . "value")))
  
  ;; Consistent behaviour for Scala backend
  (setq org-babel-default-header-args:scala
        '((:dir . nil)
          (:results . "value"))))

(use-package org-bullets
  :after org
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(setq-default fill-column 80)

(use-package visual-fill-column
  :hook
  ('eww-mode #'jp/visual-fill)
  :custom
  (visual-fill-column-enable-sensible-window-split t))

;; Visual fill to default width
(defun jp/visual-fill ()
  (interactive)
  (setq visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

;; Visual fill accounting for line numbers
(defun jp/visual-fill-87 ()
  (interactive)
  (setq visual-fill-column-width 87)
  (setq visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package org-yt
  :ensure (:repo "https://github.com/TobiasZawada/org-yt")
  :config
  (defun org-image-link (protocol link _description)
    "Interpret LINK as base64-encoded image data."
    (cl-assert (string-match "\\`img" protocol) nil
               "Expected protocol type starting with img")
    (let ((buf (url-retrieve-synchronously
                (concat (substring protocol 3) ":" link))))
      (cl-assert buf nil
                 "Download of image \"%s\" failed." link)
      (with-current-buffer buf
        (goto-char (point-min))
        (re-search-forward "\r?\n\r?\n")
        (buffer-substring-no-properties (point) (point-max)))))

  (org-link-set-parameters
   "imghttp"
   :image-data-fun #'org-image-link)

  (org-link-set-parameters
   "imghttps"
   :image-data-fun #'org-image-link))

(use-package org-inline-anim
  :custom
  (org-inline-anim-loop nil))

(use-package ox-bb
  :after org
  :config
  (add-to-list 'org-export-backends 'bb))

(use-package projectile
  :config
  (projectile-mode)
  :custom
  (projectile-completion-system 'ivy)
  (projectile-project-search-path
   '("~/.emacs.d"
     "/mnt/media/papers/type-inference"
     "/mnt/projects/personal/haskell"
     "/mnt/projects/personal/org"))
  (projectile-switch-project-action #'projectile-dired))

(defun transient-prefix-object ()
  (or transient--prefix transient-current-prefix))

(use-package magit
  :after compat transient
  :commands (magit-status magit-get-current-branch)
  :config
  (setq magit-display-buffer-function
        #'magit-display-buffer-same-window-except-diff-v1))

(use-package geiser)

(use-package geiser-guile
  :after (geiser)
  :config
  (add-to-list 'geiser-guile-load-path "~/.config/guix/current/share")
  (add-to-list 'geiser-guile-load-path "~/src/nonguix"))

(use-package guix
  :after (geiser-guile))

(use-package origami
  :hook
  (emacs-lisp-mode . origami-mode)
  (racket-mode . origami-mode)
  (racket-hash-lang-mode . origami-mode)
  :custom
  (origami-fold-replacement " ⇓"))

(setq langtool-language-tool-jar
      "/usr/share/java/languagetool/languagetool.jar")

(setq langtool-bin
      "/usr/bin/languagetool")

(use-package lsp-mode
             ; :hook ((lsp-mode . lsp-enable-which-key-integration))
  )

(setq lsp-keymap-prefix "C-c l")
(setq lsp-ui-doc-show-with-mouse nil)

(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol)

(use-package lsp-treemacs
  :commands lsp-treemacs-errors-list)

(add-hook 'haskell-mode #'lsp-deferred)
(add-hook 'haskell-literal-mode #'lsp-deferred)

(add-hook 'python-mode #'lsp-deferred)

(use-package pyvenv
  :config
  (pyvenv-mode t)

  ;; Set correct Python interpreter
  (setq pyvenv-post-activate-hooks
        (list (lambda ()
                (setq python-shell-interpreter
                      (concat pyvenv-virtual-env "bin/python3")))))
  (setq pyvenv-post-deactivate-hooks
        (list (lambda ()
                (setq python-shell-interpreter "python3")))))

;(require 'rose-unicode-input-method)

(use-package racket-mode
  :hook
  (racket-mode . rose-unicode-input-method-enable)
  (racket-repl-mode . rose-unicode-input-method-enable)
  (racket-hash-lang-mode . rose-unicode-input-method-enable)
  (racket-before-run . racket-repl-clear)

  :config
  (require 'racket-xp)
  (add-hook 'racket-mode-hook #'racket-xp-mode))

(use-package lua-mode
  :after lsp-mode
  :hook (lua-mode . lsp-mode)
  :init
  (setf lsp-lua-files-associations ["*.lua" "*.script"])
  (setf lsp-enable-snippet nil))

(use-package nix-mode)

(use-package fennel-mode
  :after lsp-mode
  :hook (fennel-mode . lsp-mode))

(use-package slime
  :init
  (setq inferior-lisp-program "sbcl"))

(use-package cmake-mode)

(use-package typescript-mode)

(use-package persp-mode
  :config
  (setq persp-auto-resume-time 0)
  (setq persp-hook-up-emacs-buffer-completion t)

  (setq jp/persp-file "~/.emacs.d/persp-confs/perspectives")

  (defun jp/current-persp ()
    (alist-get 'persp (frame-parameters)))

  (defun jp/current-persp-name ()
    (safe-persp-name (jp/current-persp)))

  (defun jp/persp-save ()
    (interactive)
    (let ((name (jp/current-persp-name)))
      (persp-save-to-file-by-names jp/persp-file
                                   *persp-hash*
                                   (list name)
                                   t)))
  
  (defun jp/persp-load ()
    (interactive)
    (let ((name (jp/current-persp-name)))
      (persp-load-from-file-by-names jp/persp-file
                                     *persp-hash*
                                     `(,name))))

  (defun jp/persp-load-all ()
    (interactive)
    (persp-load-state-from-file jp/persp-file))

  ;; btm
  (persp-def-buffer-save/load
   :mode 'btm-mode :tag-symbol 'def-btm-buffer
   :save-vars '(major-mode default-directory))

  ;; eshell
  (persp-def-buffer-save/load
   :mode 'eshell-mode :tag-symbol 'def-eshell-buffer
   :save-vars '(major-mode default-directory))

  ;; compile
  (persp-def-buffer-save/load
   :mode 'compilation-mode :tag-symbol 'def-compilation-buffer
   :save-vars '(major-mode default-directory compilation-directory
                           compilation-environment compilation-arguments))

  ;; magit-status
                                        ;(with-eval-after-load "magit-autoloads"
                                        ;  (autoload 'magit-status-mode "magit")
                                        ;  (autoload 'magit-refresh "magit")
                                        ;  (persp-def-buffer-save/load
                                        ;   :mode 'magit-status-mode :tag-symbol 'def-magit-status-buffer
                                        ;   :save-vars '(major-mode default-directory)
                                        ;   :after-load-function #'(lambda (b &rest _)
                                        ;                            (with-current-buffer b (magit-refresh)))))
  
  (defun jp/emms-browser-create (_)
    "Create a new emms-browser buffer and start emms-browser-mode."
    (let ((buffer (generate-new-buffer emms-browser-buffer-name)))
      (with-current-buffer buffer
        (emms-browser-mode)
        (emms-browser-run-mode-hooks 'emms-browser-show-display-hook))))
  
  (advice-add 'emms-browser-create :around #'jp/emms-browser-create)
  
  (defun jp/emms-browser-clear (_)
    "Create or clear the browser buffer without switching to it."
    (let ((buf (emms-browser-get-buffer)))
      (if buf
          (progn
            (with-current-buffer buf
              (emms-with-inhibit-read-only-t
               (delete-region (point-min) (point-max)))))
        (emms-browser-create))))
  
  (advice-add 'emms-browser-clear :around #'jp/emms-browser-clear)
  
  ;; EMMS Browser
  (persp-def-buffer-save/load
   :mode 'emms-browser-mode :tag-symbol 'def-emms-browser-buffer
   :save-vars '(major-mode default-directory)
   :after-load-function #'(lambda (b &rest _)
                            (message "Updating EMMS browser buffer %s" b)
                            (with-current-buffer b (emms-browser-show-all))))
  
  (defun jp/error-to-message (orig)
    "Generic advice function for redirecting errors to message output."
    (condition-case res (funcall orig)
      (error (message "%s" res))))
  
  (advice-add 'emms-playlist-first :around #'jp/error-to-message)
  
  ;; EMMS Playlist
  (persp-def-buffer-save/load
   :mode 'emms-playlist-mode :tag-symbol 'def-emms-playlist-buffer
   :save-vars '(major-mode default-directory emms-playlist-buffer-p)
   :after-load-function #'(lambda (b &rest _)
                            (message "Settings EMMS playlist buffer to %s" b)
                            (emms-playlist-set-playlist-buffer b)))
  
  ;; EMMS Metaplaylist
  (persp-def-buffer-save/load
   :mode 'emms-metaplaylist-mode :tag-symbol 'def-emms-metaplaylist-buffer
   :save-vars '(major-mode default-directory)
   :after-load-function #'(lambda (b &rest _)
                            (message "Updating metaplaylist buffer %s" b)
                            (with-current-buffer b (emms-metaplaylist-mode-update))))
  
  ;; Dashboard
  (persp-def-buffer-save/load
   :mode 'dashboard-mode :tag-symbol 'def-dashboard-buffer
   :save-vars '(major-mode default-directory))
  
  (persp-mode 1)
  (jp/persp-load-all)
  
  :config
  ;; Integrate counsel-switch-buffer
  (add-hook 'ivy-ignore-buffers
            #'(lambda (b)
                (when persp-mode
                  (let ((persp (get-current-persp)))
                    (if persp
                        (not (persp-contain-buffer-p b persp))
                      nil)))))
  
  (setq ivy-sort-functions-alist
        (append ivy-sort-functions-alist
                '((persp-kill-buffer   . nil)
                  (persp-remove-buffer . nil)
                  (persp-add-buffer    . nil)
                  (persp-switch        . nil)
                  (persp-window-switch . nil)
                  (persp-frame-switch  . nil))))
  
  ;; Order perspectives by recency
  (with-eval-after-load "persp-mode"
    (add-hook 'persp-before-switch-functions
              #'(lambda (new-persp-name w-or-f)
                  (let ((cur-persp-name (safe-persp-name (get-current-persp))))
                    (when (member cur-persp-name persp-names-cache)
                      (persp-update-names-cache (cons cur-persp-name
                                                      (remove cur-persp-name
                                                              persp-names-cache)))))))
    
    (add-hook 'persp-renamed-functions
              #'(lambda (persp old-name new-name)
                  (persp-update-names-cache (cons new-name (remove old-name persp-names-cache)))))))

(save-place-mode 1)

(require 're-builder)
(setq reb-re-syntax 'string)

(use-package ligature
  :config
  ;; Enable the "www" ligature in every possible major mode
  (ligature-set-ligatures 't '("www"))

  ;; Enable the "www" ligature in every possible major mode
  (ligature-set-ligatures 't '("www"))

  ;; Enable traditional ligature support in eww-mode, if the
  ;; `variable-pitch' face supports it
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))

  ;; Enable all Cascadia and Fira Code ligatures in programming modes
  (ligature-set-ligatures '(prog-mode racket-hash-lang-mode comint-mode eshell-mode)
                          '(;; == === ==== => =| =>>=>=|=>==>> ==< =/=//=// =~
                            ;; =:= =!=
                            ("=" (rx (+ (or ">" "<" "|" "/" "~" ":" "!" "="))))
                            ;; ;; ;;;
                            (";" (rx (+ ";")))
                            ;; && &&&
                            ("&" (rx (+ "&")))
                            ;; !! !!! !. !: !!. != !== !~
                            ("!" (rx (+ (or "=" "!" "\." ":" "~"))))
                            ;; ?? ??? ?:  ?=  ?.
                            ("?" (rx (or ":" "=" "\." (+ "?"))))
                            ;; %% %%%
                            ("%" (rx (+ "%")))
                            ;; |> ||> |||> ||||> |] |} || ||| |-> ||-||
                            ;; |->>-||-<<-| |- |== ||=||
                            ;; |==>>==<<==<=>==//==/=!==:===>
                            ("|" (rx (+ (or ">" "<" "|" "/" ":" "!" "}" "\]"
                                            "-" "=" ))))
                            ;; \\ \\\ \/
                            ("\\" (rx (or "/" (+ "\\"))))
                            ;; ++ +++ ++++ +>
                            ("+" (rx (or ">" (+ "+"))))
                            ;; :: ::: :::: :> :< := :// ::=
                            (":" (rx (or ">" "<" "=" "//" ":=" (+ ":"))))
                            ;; // /// //// /\ /* /> /===:===!=//===>>==>==/
                            ("/" (rx (+ (or ">"  "<" "|" "/" "\\" "\*" ":" "!"
                                            "="))))
                            ;; .. ... .... .= .- .? ..= ..<
                            ("\." (rx (or "=" "-" "\?" "\.=" "\.<" (+ "\."))))
                            ;; -- --- ---- -~ -> ->> -| -|->-->>->--<<-|
                            ("-" (rx (+ (or ">" "<" "|" "~" "-"))))
                            ;; *> */ *)  ** *** ****
                            ("*" (rx (or ">" "/" ")" (+ "*"))))
                            ;; www wwww
                            ("w" (rx (+ "w")))
                            ;; <> <!-- <|> <: <~ <~> <~~ <+ <* <$ </  <+> <*>
                            ;; <$> </> <|  <||  <||| <|||| <- <-| <-<<-|-> <->>
                            ;; <<-> <= <=> <<==<<==>=|=>==/==//=!==:=>
                            ;; << <<< <<<<
                            ("<" (rx (+ (or "\+" "\*" "\$" "<" ">" ":" "~"  "!"
                                            "-"  "/" "|" "="))))
                            ;; >: >- >>- >--|-> >>-|-> >= >== >>== >=|=:=>>
                            ;; >> >>> >>>>
                            (">" (rx (+ (or ">" "<" "|" "/" ":" "=" "-"))))
                            ;; #: #= #! #( #? #[ #{ #_ #_( ## ### #####
                            ("#" (rx (or ":" "=" "!" "(" "\?" "\[" "{" "_(" "_"
                                         (+ "#"))))
                            ;; ~~ ~~~ ~=  ~-  ~@ ~> ~~>
                            ("~" (rx (or ">" "=" "-" "@" "~>" (+ "~"))))
                            ;; __ ___ ____ _|_ __|____|_
                            ("_" (rx (+ (or "_" "|"))))
                            ;; Fira code: 0xFF 0x12
                            ("0" (rx (and "x" (+ (in "A-F" "a-f" "0-9")))))
                            ;; Fira code:
                            "Fl"  "Tl"  "fi"  "fj"  "fl"  "ft"
                            ;; The few not covered by the regexps.
                            "{|"  "[|"  "]#"  "(*"  "}#"  "$>"  "^="))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))

(defun jp/company-c-ret ()
  (interactive)
  (company-complete-selection)
  (when eshell-mode
    (eshell-send-input)))
  
(use-package company
  :hook
  (eshell-mode . company-mode)
  :config
  (setq company-idle-delay 0.001)
  (setq company-minimum-prefix-length 1)
  (setq company-selection-wrap-around 1)

  ;; Company appears to override the above keymap based on company-auto-complete-chars.
  ;; Turning it off ensures we have full control.
  (setq company-auto-complete-chars nil))

(use-package ace-popup-menu
  :config
  (ace-popup-menu-mode 1))

(use-package marginalia
  :config
  (marginalia-mode 1))

(use-package embark
  :config
  (defun embark-which-key-prompter (keymap update)
    (which-key--show-keymap "Embark" keymap nil nil t)
    (embark-keymap-prompter keymap update))

  (setf embark-prompter #'embark-which-key-prompter)

  (setq embark-indicators
        '(embark-minimal-indicator
          embark-highlight-indicator
          embark-isearch-highlight-indicator)))

(use-package avy
  :config
  (setq avy-all-windows 'all-frames)
  (setq avy-timeout-seconds 0.25)

  (defun avy-action-embark (pt)
    (unwind-protect
        (save-excursion
          (goto-char pt)
          (embark-act))
      (select-window
       (cdr (ring-ref avy-ring 0))))
    t)

  (setf (alist-get ?. avy-dispatch-alist) 'avy-action-embark))

(use-package ace-window
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l ?p))
  (setq aw-make-frame-char nil)
  (ace-window-display-mode 1))

(use-package buffer-name-relative
  :config
  (buffer-name-relative-mode 1))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  (counsel-describe-symbol-function #'helpful-symbol))

(use-package dashboard
  :config
  (dashboard-setup-startup-hook)

  :custom
  (dashboard-startup-banner 'logo)
  (initial-buffer-choice (lambda ()
                           (get-buffer-create dashboard-buffer-name)
                           (dashboard-refresh-buffer)))
  (dashboard-display-icons-p t)
  (dashboard-icon-type 'nerd-icons)
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  (dashboard-navigation-cycle t)
  (dashboard-center-content t)
  (dashboard-vertically-center-content t)
  (dashboard-projects-backend 'projectile)
  (dashboard-items '((recents   . 5)
                     (bookmarks . 5)
                     (projects  . 5)
                     (registers . 5)))
  (dashboard-projects-switch-function 'counsel-projectile-switch-project-by-name))

(use-package password-store-otp
  :ensure (:version (lambda (_) "0.1.5")))

(use-package pass
  :custom
  (epg-pinentry-mode 'loopback))

(use-package treemacs
  :init
  (setq treemacs--project-follow-delay 0.2)
  :config
  (treemacs-project-follow-mode 1)
  (treemacs-toggle-show-dotfiles)
  (treemacs-hide-gitignored-files-mode 1))

(use-package treemacs-projectile)

(use-package emacs
    :ensure nil
    :after shrface
    :config
    (advice-add 'eww-display-html :around #'shrface-eww-advice)
    (add-hook 'eww-after-render-hook #'org-indent-mode)
    (add-hook 'eww-after-render-hook #'eldoc-mode)
                                        ;(add-hook 'eww-after-render-hook #'eldoc-box-hover-mode)
    (add-hook 'eww-after-render-hook #'shrface-eww-setup)
    (defun shrface-eww-setup ()
      (unless shrface-toggle-bullets
        (shrface-regexp)
        (setq-local imenu-create-index-function #'shrface-imenu-get-tree))
      ;; (add-function :before-until (local 'eldoc-documentation-function) #'paw-get-eldoc-note)
      ;; workaround to show annotations in eww
      (when (bound-and-true-p paw-annotation-mode)
        (paw-clear-annotation-overlay)
        (paw-show-all-annotations)
        (if paw-annotation-show-unknown-words-p
            (paw-focus-find-unknown-words))))

    (defun shrface-eww-advice (orig-fun &rest args)
      (require 'eww)
      (let ((shrface-org nil)
            (shr-bullet (concat (char-to-string shrface-item-bullet) " "))
            (shr-table-vertical-line "|")
            (shr-max-width nil)
            ;(shr-indentation 0)
            (shr-external-rendering-functions
             (append '((title . eww-tag-title)
                       (form . eww-tag-form)
                       (input . eww-tag-input)
                       (button . eww-form-submit)
                       (textarea . eww-tag-textarea)
                       (select . eww-tag-select)
                       (link . eww-tag-link)
                       (meta . eww-tag-meta)
                       ;; (a . eww-tag-a)
                       (code . shrface-tag-code))
                     shrface-supported-faces-alist))
            (shrface-toggle-bullets nil)
            (shrface-href-versatile t)
            (shr-use-fonts nil))
        (apply orig-fun args)))
     :custom
     (eww-auto-rename-buffer t))

(use-package transmission
  :custom
  (transmission-refresh-interval 0.5)
  (transmission-refresh-modes '(transmission-mode
                                transmission-files-mode
                                transmission-info-mode
                                transmission-peers-mode)))

(use-package general
  :config
  ;; Setup prefices
  (define-prefix-command 'jp/prefix-r nil "jp/prefix-r")

  (defconst jp/prefix-r "C-SPC")

  (general-create-definer jp/prefix-r-def
    :prefix jp/prefix-r)

  ;; Setup minor mode
  (defvar jp/minor-mode-map (make-sparse-keymap)
    "Keymap for jp/minor-mode.")

  ;; Minor mode overrides
  (define-minor-mode jp/minor-mode
    "A minor mode so that my key settings override annoying major modes."
    :init-value t
    :lighter " jp/minor-mode"
    :keymap jp/minor-mode-map)

  (define-globalized-minor-mode jp/global-minor-mode jp/minor-mode jp/minor-mode)

  (add-to-list 'emulation-mode-map-alists `((jp/minor-mode . ,jp/minor-mode-map)))

  (defun jp/turn-off-minor-mode ()
    (jp/minor-mode -1))

  (add-hook 'minibuffer-setup-hook #'jp/turn-off-minor-mode)
  (provide 'jp/minor-mode)

  (defun jp/insert-lambda ()
    (interactive)
    (insert "λ"))

  ;; Superglobal minor mode mappings
  (general-define-key
   :keymaps 'jp/minor-mode-map
   "s-[" #'counsel-linux-app
   "s-x" #'counsel-M-x
   "C-c \\" #'jp/insert-lambda)

  ;; Global mappings
  (general-define-key
   ;; Prefices
   "C-SPC" #'jp/prefix-r

   ;; Override find-file and switch-buffer with their ivy equivalents
   "C-x f" #'counsel-find-file
   "C-x b" #'counsel-switch-buffer
   "C-x C-b" #'counsel-switch-buffer

   ;; Jump to dired with C-x C-j
   "C-x C-j" #'dired-jump
   "C-x j" #'dired-jump

   ;; Org bindings
   "C-c l" #'org-store-link
   "C-c a" #'org-agenda
   "C-c c" #'org-capture
   
   ;; Projectile
   "C-c p" #'projectile-command-map
   )

  (defun jp/projectile-multi-occur (&optional nlines)
    (interactive)
    (let ((project (projectile-acquire-root))
          (thing (ivy-thing-at-point))
          (display-buffer-overriding-action '(display-buffer-below-selected)))
      (occur-1 thing 
               nlines
               (projectile-project-buffers project))
      thing))

  (defun jp/projectile-refactor ()
    (interactive)
    (let ((thing (jp/projectile-multi-occur))
          (buffer (get-buffer "*Occur*")))
      (select-window (get-buffer-window buffer))
      (occur-next)
      (search-backward thing)
      (occur-edit-mode)
      (iedit-mode)
      (local-set-key [remap evil-record-macro] #'kill-buffer-and-window)
      (local-set-key [remap occur-cease-edit] #'kill-buffer-and-window)))

  (defun jp/racket-sexp-comment ()
    (interactive)
    (insert "#;"))

  ;; Right prefix - core operations
  (jp/prefix-r-def
    ;; Home row
    "h" #'recompile
    "C-h" #'recompile

    "j" #'embark-act
    "C-j" #'embark-act

    "k" #'avy-goto-char-timer
    "C-k" #'avy-goto-char-timer
    
    "l" #'ace-window
    "C-l" #'ace-window
    
    "p" #'persp-switch
    "C-p" #'persp-switch
    
    ;; Top row - special editing
    "u" #'org-edit-special
    "C-u" #'org-edit-special
    
    "i" #'indent-pp-sexp
    "C-i" #'indent-pp-sexp
    
    "o" #'org-babel-execute-buffer
    "C-o" #'org-babel-execute-buffer
    
    ";" #'eval-region
    "C-;" #'eval-region

    ;; Bottom row - refactoring
    "m" #'jp/projectile-refactor
    "C-m" #'jp/projectile-refactor

    "," #'jp/projectile-multi-occur
    "C-," #'jp/projectile-multi-occur

    "." #'iedit-mode
    "C-." #'iedit-mode)

  ;; Evil overrides
  (general-define-key
   :states 'normal
   "<escape>" #'evil-escape
   "C-<escape>" #'universal-argument)

  (general-define-key
   :states 'insert
   "C-h" #'evil-delete-backward-char-and-join
   "TAB" #'tab-to-tab-stop
   ;; Prevent interference with C-jkd commands in the minibuffer
   ;; TODO: Probably better to write predicated versions a-la evil-escape
   "C-j" nil
   "C-k" nil
   "C-d" nil)

  ;; Ensure our custom universal argument works for multiple args
  (general-define-key
   :keymaps 'universal-argument-map
   "C-<escape>" #'universal-argument-more)

  ;; Override symex for better modal behaviour
  (general-define-key
   :states 'normal
   :keymaps 'symex-lisp-mode-map
   "<escape>" #'jp/evil-esc
   "<delete>" #'symex-mode-interface)

  (general-define-key
   :states 'insert
   :keymaps 'symex-lisp-mode-map
   "<escape>" #'jp/evil-esc)

  ;; Mode-specific mappings

  ;; Programming modes
  (general-define-key
   :keymaps 'prog-mode-map
   "C-SPC u" #'org-edit-src-exit
   "C-SPC C-u" #'org-edit-src-exit)

  ;; EMMS Playlist
  (general-define-key
   :keymaps 'emms-playlist-mode-map
   ;; Remap buffer switch to playlist switch in EMMS playlist / metaplaylist buffers
   "C-x b" #'emms-metaplaylist-mode-go
   "C-x C-b" #'emms-metaplaylist-mode-go
   "C-x b" #'emms-metaplaylist-mode-go
   "C-x C-b" #'emms-metaplaylist-mode-go)

  ;; EMMS Meta-Playlist
  (general-define-key
   :keymaps 'emms-metaplaylist-mode-map
   ;; Remap quit to display current playlist in EMMS metaplaylist buffer
   "C-g" #'jp/emms-playlist-switch-buffer)

  ;; EMMS Browser
  (general-define-key
   :keymaps 'emms-browser-mode-map
   "C-x b" #'emms-browser-switch-filter
   "C-x C-b" #'emms-browser-switch-filter)

  ;; Dired
  (general-define-key
   :keymaps 'dired-mode-map
   :states 'normal
   "h" 'dired-single-up-directory
   "l" 'dired-single-buffer
   "H" 'dired-hide-dotfiles-mode)

  ;; Eshell
  (general-define-key
   :states '(normal insert visual)
   :keymaps 'eshell-mode-map
   "C-r" #'counsel-esh-history
   "<home>" #'eshell-bol)

  ;; Origami
  (general-define-key
   :states 'normal
   :keymaps 'origami-mode-map
   "<tab>" #'origami-toggle-node
   "<backtab>" #'origami-toggle-all-nodes)

  ;; Persp-mode
  (general-define-key
   :keymaps 'persp-key-map
   "w" #'jp/persp-save
   "l" #'jp/persp-load)

  ;; Ivy
  (general-define-key
   [remap describe-function] #'counsel-describe-function
   [remap describe-command] #'helpful-command
   [remap describe-variable] #'counsel-describe-variable
   [remap describe-symbol] #'counsel-describe-symbol
   [remap describe-key] #'helpful-key)

  ;; Company
  (general-define-key
   :keymaps 'company-active-map
   "<tab>" #'company-complete-selection
   "<space>" nil
   "C-<return>" #'jp/company-c-ret)

  (dolist (key '("<return>" "RET")) ;; <return> for windowed Emacs; RET for terminal
    ;; Here we are using an advanced feature of define-key that lets
    ;; us pass an "extended menu item" instead of an interactive
    ;; function. Doing this allows RET to regain its usual
    ;; functionality when the user has not explicitly interacted with
    ;; Company.
    (general-define-key
     :keymaps 'company-active-map
     key
     `(menu-item nil company-complete
                 :filter ,(lambda (cmd)
                            (when (company-explicit-action-p)
                              cmd)))))

  ;; Enable minor mode globally
  (jp/global-minor-mode 1))
