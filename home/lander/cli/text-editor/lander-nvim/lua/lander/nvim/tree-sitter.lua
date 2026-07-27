-- [nfnl] fnl/lander/nvim/tree-sitter.fnl


 local function _1_(args)

 local function _2_()
 return pcall(vim.treesitter.start, args.buf) end return vim.schedule(_2_) end return vim.api.nvim_create_autocmd({"BufReadPost", "BufNewFile"}, {pattern = "*", callback = _1_})
