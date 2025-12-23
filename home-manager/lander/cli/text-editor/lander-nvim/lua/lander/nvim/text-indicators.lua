 local dracula = require("dracula.palette")

 vim.api.nvim_set_hl(0, "Whitespace", {fg = dracula.comment})
 vim.api.nvim_set_hl(0, "NonText", {fg = dracula.comment}) vim.go.list = true vim.go.listchars = "tab:\226\128\186 ,extends:\226\134\146,precedes:\226\134\144,nbsp:\194\183,trail:\194\183"

 return nil