local conform = require("conform")
conform.setup({formatters_by_ft = {fennel = {"fnlfmt", lsp_format = "fallback"}, rust = {"rustfmt", lsp_format = "fallback"}}})
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
return nil