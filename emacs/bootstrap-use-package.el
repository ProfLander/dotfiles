;; Setup elpaca use-package integration
(elpaca elpaca-use-package
  (elpaca-use-package-mode))

(setq use-package-always-ensure t)

(when init-file-debug
  (setq use-package-verbose t
        use-package-expand-minimally nil
        use-package-compute-statistics t
        debug-on-error t))
