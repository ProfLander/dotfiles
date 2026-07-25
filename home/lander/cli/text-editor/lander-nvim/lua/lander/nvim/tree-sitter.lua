-- [nfnl] fnl/lander/nvim/tree-sitter.fnl
 local treesitter = require("nvim-treesitter")

 return treesitter.setup({highlight = {enable = true, additional_vim_regex_highlighting = false}})
