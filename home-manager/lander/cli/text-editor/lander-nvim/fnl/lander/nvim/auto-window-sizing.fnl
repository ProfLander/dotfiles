;; Automatic window sizing
(pcall vim.api.nvim_clear_autocmds {:group :auto-window-width})

(vim.api.nvim_create_augroup :auto-window-width {})

(vim.api.nvim_create_autocmd
  :WinEnter
  {:group :auto-window-width
   :callback
   (λ []
      (vim.cmd "wincmd =")
      (vim.cmd "wincmd 86|")
      false)})

