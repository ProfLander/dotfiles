;; Separator focus
(local dracula (require :dracula.palette))

(vim.api.nvim_set_hl_ns 0)

(pcall vim.api.nvim_clear_autocmds {:group :separator-focus})

(vim.api.nvim_create_augroup :separator-focus {})

(vim.api.nvim_set_hl 0 :StatusLineNC {:bg dracula.bg :fg dracula.purple})

(vim.api.nvim_create_autocmd
  :FocusLost
  {:group :separator-focus
   :callback (λ []
               (vim.api.nvim_set_hl 0 :WinSeparator
                                    {:bg :none
                                     :fg dracula.comment})
               (vim.api.nvim_set_hl 0 :StatusLine
                                    {:bg dracula.bg
                                     :fg dracula.purple}))})

(vim.api.nvim_create_autocmd
  :FocusGained
  {:group :separator-focus
   :callback (λ []
               (vim.api.nvim_set_hl 0 :WinSeparator
                                    {:bg :none
                                     :fg dracula.pink})
               (vim.api.nvim_set_hl 0 :StatusLine
                                    {:bg dracula.bg
                                     :fg dracula.pink}))})

