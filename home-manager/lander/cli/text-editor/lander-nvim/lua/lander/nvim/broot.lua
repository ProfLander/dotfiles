 local function sync_broot()
 local path = vim.api.nvim_buf_get_name(0)
 if (path ~= "") then
 local filename = string.match(path, "[^/]+$")
 if filename then
 local cmd = ("silent !broot --send main-panel-left --cmd " .. "\"" .. filename .. ";" .. ":select" .. ";" .. ":escape" .. "\"")



 vim.cmd(cmd) else end return false else return nil end end


 pcall(vim.api.nvim_clear_autocmds, {group = "broot-sync"})
 vim.api.nvim_create_augroup("broot-sync", {})
 vim.api.nvim_create_autocmd("BufEnter", {group = "broot-sync", callback = sync_broot})


 vim.api.nvim_create_autocmd("WinEnter", {group = "broot-sync", callback = sync_broot})


 vim.api.nvim_create_autocmd("TabEnter", {group = "broot-sync", callback = sync_broot})



 return sync_broot()