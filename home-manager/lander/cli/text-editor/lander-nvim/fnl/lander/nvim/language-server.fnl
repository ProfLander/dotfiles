(vim.lsp.config :bashls {:cmd [:bash-language-server]
                         :filetypes [:bash :sh]
                         :root_markers [:.git]})

(vim.lsp.enable :bashls)

(local text-filetypes [:bib
                       :gitcommit
                       :markdown
                       :org
                       :plaintex
                       :rst
                       :rnoweb
                       :tex
                       :pandoc
                       :quarto
                       :rmd
                       :context
                       :html
                       :xhtml
                       :mail
                       :text])

(local language-id-mapping {:bib :bibtex
                            :pandoc :markdown
                            :plaintex :tex
                            :rnoweb :rsweave
                            :rst :restructuredtext
                            :tex :latex
                            :text :plaintext})

(λ has-fls-project-cfg [?path]
  (local fnlpath (vim.fs.joinpath ?path :flsproject.fnl))
  (= (. (or (vim.uv.fs_stat fnlpath) {}) :type) :file))

(λ fennel-root-dir [bufnr on-dir]
  (local fname (vim.api.nvim_buf_get_name bufnr))
  (on-dir (or (: (vim.iter (vim.fs.parents fname)) :find has-fls-project-cfg)
              (vim.fs.root 0 :.git))))

(vim.lsp.config :fennel-ls {:cmd [:fennel-ls]
                            :capabilities {:offsetEncoding [:utf-8 :utf-16]}
                            :filetypes [:fennel]
                            :root_dir fennel-root-dir
                            :root_markers [:flsproject.fnl :.git]
                            :settings {}})

(vim.lsp.enable :fennel-ls)


(vim.lsp.config :ltex
                {:cmd [:ltex-ls]
                 :filetypes text-filetypes
                 :get_language_id (λ [_ filetype]
                                    (or (. language-id-mapping filetype)
                                        filetype))
                 :root_markers [:.git]
                 :settings {:ltex {:enabled text-filetypes}}})

(vim.lsp.enable :ltex)

(vim.lsp.config :nixd {:cmd [:nixd]
                       :filetypes [:nix]
                       :root_markers [:flake.nix :.git]})

(vim.lsp.enable :nixd)

(vim.lsp.config :lua_ls
                {:cmd [:lua-language-server]
                 :filetypes [:lua]
                 :root_markers [:emmyrc.json
                                :.luarc.json
                                :.luarc.jsonc
                                :.luacheckrc
                                :.stylua.toml
                                :stylua.toml
                                :selene.toml
                                :selene.yml
                                :.git]
                 :settings {:Lua {:codeLens {:enable true}
                                  :hint {:enable true :semicolon :Disable}}}})

(vim.lsp.enable :lua_ls)

(vim.lsp.config :rust-analyzer
                {:cmd [:rust-analyzer]
                 :filetypes [:rust]
                 :root_markers [:Cargo.toml :rust-project.json :.git]
                 :cargo {:buildScripts {:enable true}}
                 :procMacro {:enable true
                             :server "~/.nix-profile/bin/rust-analyzer-proc-macro-srv"}})

(vim.lsp.enable :rust-analyzer)

(λ yaml-on-init [client]
  (set client.server_capabilities.documentFormattingProvider true))

(vim.lsp.config :tombi
                {:cmd [:tombi :lsp]
                 :filetypes [:toml]
                 :root_markers [:tombi.toml "pyproject.toml" ".git"]})

(vim.lsp.enable :tombi)


(vim.lsp.config :yamlls
                {:cmd [:yaml-language-server]
                 :filetypes [:yaml
                             :yaml.docker-compose
                             :yaml.gitlab
                             :yaml.helm-values]
                 :on_init yaml-on-init
                 :root_markers [:.git]
                 :settings {:redhat {:telemetry {:enabled false}}
                            :yaml {:format {:enable true}}}})

(vim.lsp.enable :yamlls)

