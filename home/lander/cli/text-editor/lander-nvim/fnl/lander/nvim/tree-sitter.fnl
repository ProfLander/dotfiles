(vim.api.nvim_create_autocmd [:BufReadPost :BufNewFile]
 {:pattern "*"
  :callback (fn [args]
              (vim.schedule
               (fn []
                 (pcall vim.treesitter.start args.buf))))})
