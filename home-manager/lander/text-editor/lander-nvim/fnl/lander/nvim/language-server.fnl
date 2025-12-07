(local lspconfig (require :lspconfig))

(vim.lsp.config :bashls {})
(vim.lsp.enable :bashls)

(vim.lsp.config :yamlls {})
(vim.lsp.enable :yamlls)

(vim.lsp.config :ltex {})
(vim.lsp.enable :ltex)

(vim.lsp.config :nixd {})
(vim.lsp.enable :nixd)

(vim.lsp.config :luals {})
(vim.lsp.enable :luals)

(lspconfig.fennel_ls.setup {})
(vim.lsp.enable :fennel-ls)

(vim.lsp.config :rust-analyzer {})
(vim.lsp.enable :rust-analyzer)

