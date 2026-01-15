-- [nfnl] fnl/lander/nvim/rainbow-delimiters.fnl
 local dracula = require("dracula.palette")

 vim.api.nvim_set_hl(0, "RainbowDelimiterRed", {fg = dracula.red})
 vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", {fg = dracula.orange})
 vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", {fg = dracula.yellow})
 vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", {fg = dracula.green})
 vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", {fg = dracula.purple})
 vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", {fg = dracula.cyan})
 vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", {fg = dracula.pink})


 vim.g.rainbow_delimiters = {strategy = {[""] = "rainbow-delimiters.strategy.global", vim = "rainbow-delimiters.strategy.local"}, query = {[""] = "rainbow-delimiters", lua = "rainbow-blocks"}, priority = {[""] = 110, lua = 210}, highlight = {"RainbowDelimiterBlue", "RainbowDelimiterViolet", "RainbowDelimiterOrange", "RainbowDelimiterGreen", "RainbowDelimiterCyan"}} return nil
