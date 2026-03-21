(local dracula (require :dracula.palette))

(vim.api.nvim_set_hl 0 :Whitespace {:fg dracula.comment})
(vim.api.nvim_set_hl 0 :NonText {:fg dracula.comment})
(set vim.go.list true)
(set vim.go.listchars "tab:› ,extends:→,precedes:←,nbsp:·,trail:·")

