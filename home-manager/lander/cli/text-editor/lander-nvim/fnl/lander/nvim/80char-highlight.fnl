;; Highlight red past 80 characters
(pcall vim.api.nvim_clear_autocmds {:group :80char-highlight})

(vim.api.nvim_create_augroup :80char-highlight {})

(vim.api.nvim_create_autocmd
  :WinEnter
  {:group :80char-highlight
   :callback
   (λ []
      (vim.cmd "match Error /\\%81v.\\+/")
      false)})

