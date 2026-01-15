-- [nfnl] fnl/lander/nvim/80char-highlight.fnl

 pcall(vim.api.nvim_clear_autocmds, {group = "80char-highlight"})

 vim.api.nvim_create_augroup("80char-highlight", {})





 local function _1_()
 vim.cmd("match Error /\\%81v.\\+/") return false end return vim.api.nvim_create_autocmd("WinEnter", {group = "80char-highlight", callback = _1_})
