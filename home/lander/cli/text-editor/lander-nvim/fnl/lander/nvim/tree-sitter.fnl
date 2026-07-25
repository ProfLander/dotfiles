(vim.api.nvim_create_autocmd :FileType
  {:pattern "*"
   :callback (fn [args]
               (pcall vim.treesitter.start args.buf))})
