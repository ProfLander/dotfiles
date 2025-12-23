 local treesitter_configs = require("nvim-treesitter.configs")

 return treesitter_configs.setup({highlight = {enable = true, additional_vim_regex_highlighting = false}})