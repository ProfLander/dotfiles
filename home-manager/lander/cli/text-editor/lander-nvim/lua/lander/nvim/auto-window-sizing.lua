
 pcall(vim.api.nvim_clear_autocmds, {group = "auto-window-width"})

 vim.api.nvim_create_augroup("auto-window-width", {})





 local function _1_()
 vim.cmd("wincmd =")
 vim.cmd("wincmd 86|") return false end return vim.api.nvim_create_autocmd("WinEnter", {group = "auto-window-width", callback = _1_})