;; -*- lexical-binding: t -*-

(load "bootstrap-elpaca.el")

(elpaca-no-symlink-mode)
(setq elpaca-queue-limit 20)

(load "bootstrap-use-package.el")

(add-to-list 'load-path "C:/Users/Josh/AppData/Roaming/.emacs.d/lisp/")
(add-to-list 'load-path "D:/projects/personal/org/batch/")
(add-to-list 'load-path "D:/projects/personal/org/farm/")
(add-to-list 'load-path "D:/projects/personal/org/farm/ox-farm")
(add-to-list 'load-path "D:/projects/personal/org/dat/")
(add-to-list 'load-path "D:/projects/personal/org/rose-unicode-input-method/")

(load "settings.el")

(prefer-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)
