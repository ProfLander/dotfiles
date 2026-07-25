-- [nfnl] fnl/lander/nvim/tree-sitter.fnl


 local function _1_(args)
 return pcall(vim.treesitter.start, args.buf) end return vim.api.nvim_create_autocmd("FileType", {pattern = "*", callback = _1_})
