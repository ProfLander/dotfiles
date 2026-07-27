;; General-purpose
(local conform (require :conform))

(conform.setup {:default_format_opts {:lsp_format :fallback}
                :formatters_by_ft {:nix {1 :nixfmt
                                         :lsp_format :fallback}
                                   :rust {1 :rustfmt :lsp_format :fallback}}})

(set vim.o.formatexpr "v:lua.require'conform'.formatexpr()")

