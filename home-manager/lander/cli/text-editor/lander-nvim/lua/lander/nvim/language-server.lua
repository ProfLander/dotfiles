 vim.lsp.config("bashls", {cmd = {"bash-language-server"}, filetypes = {"bash", "sh"}, root_markers = {".git"}})



 vim.lsp.enable("bashls")

 local text_filetypes = {"bib", "gitcommit", "markdown", "org", "plaintex", "rst", "rnoweb", "tex", "pandoc", "quarto", "rmd", "context", "html", "xhtml", "mail", "text"}
















 local language_id_mapping = {bib = "bibtex", pandoc = "markdown", plaintex = "tex", rnoweb = "rsweave", rst = "restructuredtext", tex = "latex", text = "plaintext"}







 local function has_fls_project_cfg(_3fpath)
 local fnlpath = vim.fs.joinpath(_3fpath, "flsproject.fnl")
 return ((vim.uv.fs_stat(fnlpath) or {}).type == "file") end

 local function fennel_root_dir(bufnr, on_dir) _G.assert((nil ~= on_dir), "Missing argument on-dir on fnl/lander/nvim/language-server.fnl:36") _G.assert((nil ~= bufnr), "Missing argument bufnr on fnl/lander/nvim/language-server.fnl:36")
 local fname = vim.api.nvim_buf_get_name(bufnr)
 return on_dir((vim.iter(vim.fs.parents(fname)):find(has_fls_project_cfg) or vim.fs.root(0, ".git"))) end


 vim.lsp.config("fennel-ls", {cmd = {"fennel-ls"}, capabilities = {offsetEncoding = {"utf-8", "utf-16"}}, filetypes = {"fennel"}, root_dir = fennel_root_dir, root_markers = {"flsproject.fnl", ".git"}, settings = {}})






 vim.lsp.enable("fennel-ls")





 local function _1_(_, filetype) _G.assert((nil ~= filetype), "Missing argument filetype on fnl/lander/nvim/language-server.fnl:54")
 return (language_id_mapping[filetype] or filetype) end vim.lsp.config("ltex", {cmd = {"ltex-ls"}, filetypes = text_filetypes, get_language_id = _1_, root_markers = {".git"}, settings = {ltex = {enabled = text_filetypes}}})




 vim.lsp.enable("ltex")

 vim.lsp.config("nixd", {cmd = {"nixd"}, filetypes = {"nix"}, root_markers = {"flake.nix", ".git"}})



 vim.lsp.enable("nixd")

 vim.lsp.config("lua_ls", {cmd = {"lua-language-server"}, filetypes = {"lua"}, root_markers = {"emmyrc.json", ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git"}, settings = {Lua = {codeLens = {enable = true}, hint = {enable = true, semicolon = "Disable"}}}})














 vim.lsp.enable("lua_ls")

 vim.lsp.config("rust-analyzer", {cmd = {"rust-analyzer"}, filetypes = {"rust"}, root_markers = {"Cargo.toml", "rust-project.json", ".git"}, cargo = {buildScripts = {enable = true}}, procMacro = {enable = true, server = "~/.nix-profile/bin/rust-analyzer-proc-macro-srv"}})







 vim.lsp.enable("rust-analyzer")

 local function yaml_on_init(client) _G.assert((nil ~= client), "Missing argument client on fnl/lander/nvim/language-server.fnl:95") client.server_capabilities.documentFormattingProvider = true
 return nil end

 vim.lsp.config("tombi", {cmd = {"tombi", "lsp"}, filetypes = {"toml"}, root_markers = {"tombi.toml", "pyproject.toml", ".git"}})




 vim.lsp.enable("tombi")


 vim.lsp.config("yamlls", {cmd = {"yaml-language-server"}, filetypes = {"yaml", "yaml.docker-compose", "yaml.gitlab", "yaml.helm-values"}, on_init = yaml_on_init, root_markers = {".git"}, settings = {redhat = {telemetry = {enabled = false}}, yaml = {format = {enable = true}}}})










 return vim.lsp.enable("yamlls")