(local treesitter-configs (require :nvim-treesitter.configs))

(treesitter-configs.setup {:highlight {:enable true
                                       :additional_vim_regex_highlighting false}})

