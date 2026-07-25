-- [nfnl] fnl/lander/nvim/keymaps.fnl
 local telescope = require("telescope.builtin")

 local se = require("lander.nvim.structural-editing")
 local mc = require("multicursor-nvim") vim.g.mapleader = " " vim.g.maplocalleader = " "






 se.setup()


 vim.keymap.set({"n", "v"}, "<C-h>", se.compose(se["node-at-cursor"], se["repeat"](se["node->?intangible-parent"]), se.otherwise(se["node->parent-unless-root"], se["node-at-cursor"]), se["goto-node"]), {noremap = true})








 local function _1_(_3fnode)
 return (se["node->next-named-child"](_3fnode) or se["node->next-named-sibling"](_3fnode) or (se["node->?intangible-parent"](_3fnode) and se["node->next-named-sibling"](se["node->parent-unless-root"](_3fnode)))) end vim.keymap.set({"n", "v"}, "<C-j>", se.compose(se["node-at-cursor"], _1_, se["goto-node"]), {noremap = true})







 local function _2_(_3fnode)
 return (se["node->prev-named-child"](_3fnode) or se["node->prev-named-sibling"](_3fnode) or (se["node->?intangible-parent"](_3fnode) and se["node->prev-named-sibling"](se["node->parent-unless-root"](_3fnode)))) end vim.keymap.set({"n", "v"}, "<C-k>", se.compose(se["node-at-cursor"], _2_, se["goto-node"]), {noremap = true})





 vim.keymap.set({"n", "v"}, "<C-l>", se.compose(se["node-at-cursor"], se["node->first-named-child"], se["goto-node"]), {noremap = true})




 vim.keymap.set({"n", "v"}, "fs", se.compose(se["node-at-cursor"], se["goto-node-start"]), {desc = "goto-node-start", silent = true, noremap = true})


 vim.keymap.set({"n", "v"}, "fe", se.compose(se["node-at-cursor"], se["goto-node-end"]), {desc = "goto-node-end", silent = true, noremap = true})


 vim.keymap.set({"n", "v"}, "Fs", se.compose(se["node-at-cursor"], se["node->parent"], se["goto-node-start"]), {desc = "goto-parent-start", silent = true, noremap = true})




 vim.keymap.set({"n", "v"}, "Fe", se.compose(se["node-at-cursor"], se["node->parent"], se["goto-node-end"]), {desc = "goto-parent-end", silent = true, noremap = true})




 vim.keymap.set({"o"}, "f", se.compose(se["node-at-cursor"], se["around-node"]), {desc = "around-node", silent = true, noremap = true})


 vim.keymap.set({"x", "o"}, "af", se.compose(se["node-at-cursor"], se["around-node"]), {desc = "around-node", silent = true, noremap = true})


 vim.keymap.set({"x", "o"}, "aF", se.compose(se["node-at-cursor"], se["node->parent"], se["around-node"]), {desc = "around-node", silent = true, noremap = true})



 vim.keymap.set({"x", "o"}, "if", se.compose(se["node-at-cursor"], se["inside-node"]), {desc = "inside-node", silent = true, noremap = true})


 vim.keymap.set({"x", "o"}, "iF", se.compose(se["node-at-cursor"], se.parent, se["inside-node"]), {desc = "inside-node", silent = true, noremap = true})




 vim.keymap.set({"n"}, "yf", ":normal m'yaf`'<cr>", {desc = "yank-form", silent = true, remap = true})




 vim.keymap.set({"n"}, "fi", se.compose(se["node-at-cursor"], se["goto-node-start"], se["start-insert"]), {desc = "insert-at-form", silent = true, noremap = true})



 vim.keymap.set({"n"}, "fI", se.compose(se["node-at-cursor"], se["goto-node-start"], se["start-insert"], se["push-text"](" ")), {desc = "insert-before-form", silent = true, noremap = true})




 vim.keymap.set({"n"}, "Fi", se.compose(se["node-at-cursor"], se["node->parent"], se["goto-node-start"], se["start-insert"]), {desc = "insert-at-parent", silent = true, noremap = true})




 vim.keymap.set({"n"}, "FI", se.compose(se["node-at-cursor"], se["node->parent"], se["goto-node-start"], se["start-insert"], se["push-text"](" ")), {desc = "insert-before-parent", silent = true, noremap = true})






 vim.keymap.set({"n"}, "fa", se.compose(se["start-insert"], se.const(nil), se["node-at-cursor"], se["goto-node-end"], se.input("<Right>")), {desc = "append-at-form", silent = true, noremap = true})




 vim.keymap.set({"n"}, "fA", se.compose(se["start-insert"], se.const(nil), se["node-at-cursor"], se["goto-node-end"], se.input("<Right> ")), {desc = "append-after-form", silent = true, noremap = true})




 vim.keymap.set({"n"}, "Fa", se.compose(se["start-insert"], se.const(nil), se["node-at-cursor"], se["node->parent"], se["goto-node-end"], se.input("<Right>")), {desc = "append-at-parent", silent = true, noremap = true})




 vim.keymap.set({"n"}, "FA", se.compose(se["start-insert"], se.const(nil), se["node-at-cursor"], se["node->parent"], se["goto-node-end"], se.input("<Right> ")), {desc = "append-after-parent", silent = true, noremap = true})






 vim.keymap.set({"n"}, "fo", se.compose(se["start-insert"], se.const(nil), se["node-at-cursor"], se["goto-node-end"], se.input("<Right>\r")), {desc = "open-after-form", silent = true, noremap = true})




 vim.keymap.set({"n"}, "fO", se.compose(se["start-insert"], se.const(nil), se["node-at-cursor"], se["goto-node-start"], se.command("normal! i\r\27`["), se.input("<Right>")), {desc = "open-before-form", silent = true, noremap = true})





 vim.keymap.set({"n"}, "Fo", se.compose(se["start-insert"], se.const(nil), se["node-at-cursor"], se["node->parent"], se["goto-node-end"], se.input("<Right>\r")), {desc = "open-after-parent", silent = true, noremap = true})





 vim.keymap.set({"n"}, "FO", se.compose(se["start-insert"], se.const(nil), se["node-at-cursor"], se["node->parent"], se["goto-node-start"], se.command("normal! i\r\27`["), se.input("<Right>")), {desc = "open-before:parent", silent = true, noremap = true})






 vim.keymap.set({"n"}, "fj", se.compose(se["node-at-cursor"], se["node-split-forward"]), {desc = "split-form", silent = true, noremap = true})


 vim.keymap.set({"n"}, "fk", se.compose(se["node-at-cursor"], se["node-join-backward"]), {desc = "join-form", silent = true, remap = true})



 vim.keymap.set({"n"}, "df", se.compose(se["node-at-cursor"], se["node-delete"]), {desc = "delete-form", silent = true, noremap = true})



 vim.keymap.set({"n"}, "fz", se.compose(se["node-at-cursor"], se["node-unwrap"]), {desc = "unwrap-form", silent = true, noremap = true})



 vim.keymap.set({"n"}, "fq", ":normal m'vafgq`'<cr>", {desc = "format-form", silent = true, remap = true})


 vim.keymap.set({"n"}, "Fq", ":normal m'vaFgq`'<cr>", {desc = "format-parent", silent = true, remap = true})


 vim.keymap.set({"n"}, "fw", ":normal m'vafgw`'<cr>", {desc = "format-form", silent = true, remap = true})


 vim.keymap.set({"n"}, "Fw", ":normal m'vaFgw`'", {desc = "format-parent", silent = true, remap = true})



 vim.keymap.set({"n"}, "fp", se.compose(se["node-at-cursor"], se["node-paste-after"]), {desc = "paste-after-form", silent = true, noremap = true})


 vim.keymap.set({"n"}, "fP", se.compose(se["node-at-cursor"], se["node-paste-before"]), {desc = "paste-before-form", silent = true, noremap = true})



 vim.keymap.set({"n"}, "fw(", "ysf)a", {desc = "wrap-in-paren", silent = true, remap = true})


 vim.keymap.set({"n"}, "fw)", "ysf)", {desc = "wrap-with-paren", silent = true, remap = true})


 vim.keymap.set({"n"}, "fw[", "ysf]a", {desc = "wrap-in-bracket", silent = true, remap = true})


 vim.keymap.set({"n"}, "fw]", "ysf]", {desc = "wrap-with-bracket", silent = true, remap = true})


 vim.keymap.set({"n"}, "fw{", "ysf}a", {desc = "wrap-in-brace", silent = true, remap = true})


 vim.keymap.set({"n"}, "fw}", "ysf}", {desc = "wrap-with-brace", silent = true, remap = true})


 vim.keymap.set({"n"}, "fw\"", "ysf\"a", {desc = "wrap-in-quote", silent = true, remap = true})


 vim.keymap.set({"n"}, "fw\"", "ysf\"", {desc = "wrap-with-quote", silent = true, remap = true})



 vim.keymap.set({"n"}, "<S-h>", se["drag-node-up"], {desc = "drag-form-up", silent = true, noremap = true})


 vim.keymap.set({"n"}, "<S-j>", se["drag-node-next"], {desc = "drag-form-next", silent = true, noremap = true})


 vim.keymap.set({"n"}, "<S-k>", se["drag-node-prev"], {desc = "drag-form-prev", silent = true, noremap = true})



 vim.keymap.set({"n"}, "<S-l>", ":normal! m'J`'<cr>", {desc = "join-in-place", silent = true, noremap = true})



 vim.keymap.set({"n"}, "<C-S-h>", se.compose(se["node-at-cursor"], se["slurp-prev"]), {desc = "slurp-backward", silent = true, noremap = true})


 vim.keymap.set({"n"}, "<C-S-l>", se.compose(se["node-at-cursor"], se["slurp-next"]), {desc = "slurp-forward", silent = true, noremap = true})



 vim.keymap.set({"n"}, "<C-S-j>", se.compose(se["node-at-cursor"], se["barf-prev"]), {desc = "barf-backward", silent = true, noremap = true})


 vim.keymap.set({"n"}, "<C-S-k>", se.compose(se["node-at-cursor"], se["barf-next"]), {desc = "barf-forward", silent = true, noremap = true})



 local function _3_()
 vim.cmd("noh")
 return mc.clearCursors() end vim.keymap.set({"n"}, "<esc>", _3_, {desc = "dismiss-search-highlight", silent = true, noremap = true})



 vim.keymap.set({"n"}, "<Leader>u", ":UndotreeToggle<cr>", {desc = "toggle-undo-tree", silent = true, noremap = true})



 vim.keymap.set("n", "<Backspace><Backspace>", telescope.builtin, {desc = "builtin"})
 vim.keymap.set("n", "<Backspace>b", telescope.buffers, {desc = "buffers"})
 vim.keymap.set("n", "<Backspace>k", telescope.keymaps, {desc = "keymaps"})
 vim.keymap.set("n", "<Backspace>d", telescope.diagnostics, {desc = "diagnostics"})
 vim.keymap.set("n", "<Backspace>c", telescope.commands, {desc = "commands"})
 vim.keymap.set("n", "<Backspace>h", telescope.help_tags, {desc = "help-tags"})
 vim.keymap.set("n", "<Backspace>j", telescope.jumplist, {desc = "jump-list"})
 vim.keymap.set("n", "<Backspace>l", telescope.loclist, {desc = "loc-list"})
 vim.keymap.set("n", "<Backspace>m", telescope.marks, {desc = "marks"})
 vim.keymap.set("n", "<Backspace>r", telescope.registers, {desc = "registers"})
 vim.keymap.set("n", "<Backspace>o", telescope.vim_options, {desc = "vim-options"})
 vim.keymap.set("n", "<Backspace>g", telescope.live_grep, {desc = "live-grep"})

 vim.keymap.set("n", "<Backspace>sd", telescope.lsp_definitions, {desc = "lsp-definitions"})


 vim.keymap.set("n", "<Backspace>sr", telescope.lsp_references, {desc = "lsp-references"})


 vim.keymap.set("n", "<Backspace>sci", telescope.lsp_incoming_calls, {desc = "lsp-incoming-calls"})


 vim.keymap.set("n", "<Backspace>sco", telescope.lsp_outgoing_calls, {desc = "lsp-outgoing-calls"})


 vim.keymap.set("n", "<Backspace>si", telescope.lsp_implementations, {desc = "lsp-implementations"})


 vim.keymap.set("n", "<Backspace>st", telescope.lsp_type_definitions, {desc = "lsp-type-definitions"})


 vim.keymap.set("n", "<Backspace>sds", telescope.lsp_document_symbols, {desc = "lsp-document-symbols"})


 vim.keymap.set("n", "<Backspace>sws", telescope.lsp_workspace_symbols, {desc = "lsp-workspace-symbols"})


 vim.keymap.set("n", "<Backspace>sdws", telescope.lsp_dynamic_workspace_symbols, {desc = "lsp-dynamic-workspace-symbols"})



 local function _4_() return mc.lineAddCursor(-1) end vim.keymap.set({"n", "x"}, "<C-Up>", _4_, {desc = "lsp-dynamic-workspace-symbols"})


 local function _5_() return mc.lineAddCursor(1) end vim.keymap.set({"n", "x"}, "<C-Down>", _5_, {desc = "lsp-dynamic-workspace-symbols"})



 local function niri_focus(target) if (nil == target) then _G.error("Missing argument target on /home/lander/src/dotfiles/home/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/keymaps.fnl:296", 2) else end
 return vim.cmd(("silent !niri msg action focus-window --id " .. target)) end

 local function broot_send(target, cmd) if (nil == cmd) then _G.error("Missing argument cmd on /home/lander/src/dotfiles/home/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/keymaps.fnl:299", 2) else end if (nil == target) then _G.error("Missing argument target on /home/lander/src/dotfiles/home/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/keymaps.fnl:299", 2) else end
 local function _9_()
 local cmd0 = cmd()
 cmd0 = ("silent !broot --send " .. target .. " --cmd \"" .. cmd0 .. "\"")
 vim.cmd(cmd0)
 local target0 = vim.api.nvim_exec(("silent !app-id-to-niri-id " .. target), true)

 target0 = tonumber(string.match(target0, "[0-9]+"))
 return niri_focus(target0) end return _9_ end

 local function current_buffer_name(_3fbufnr)
 local bufnr = (_3fbufnr or 0)
 return vim.api.nvim_buf_get_name(bufnr) end



 local function _10_() return (":clean " .. current_buffer_name()) end vim.keymap.set({"n"}, "<F2>", broot_send("main-panel-right", _10_), {silent = true})




 local function _11_() return (":build " .. current_buffer_name()) end vim.keymap.set({"n"}, "<F3>", broot_send("main-panel-right", _11_), {silent = true})




 local function _12_() return (":run " .. current_buffer_name()) end vim.keymap.set({"n"}, "<F4>", broot_send("main-panel-right", _12_), {silent = true})




 local function _13_() return (":test " .. current_buffer_name()) end vim.keymap.set({"n"}, "<F5>", broot_send("main-panel-right", _13_), {silent = true})




 vim.keymap.set({"n"}, "<Leader>j", vim.diagnostic.open_float, {desc = "LSP diagnostic", silent = true})


 vim.keymap.set({"n"}, "<Leader>k", vim.lsp.buf.hover, {desc = "LSP hover", silent = true})



 pcall(vim.api.clear_autocmds, {group = "lander-nvim"})
 vim.api.nvim_create_augroup("lander-nvim", {})


 vim.keymap.set({"n"}, "<C-z>", ":normal i\206\187<cr>", {silent = true, noremap = true})
 vim.keymap.set({"i"}, "<C-z>", "\206\187", {silent = true, noremap = true})
 vim.keymap.set({"n"}, "<C-S-z>", ":normal i\206\155<cr>", {silent = true, noremap = true})
 vim.keymap.set({"i"}, "<C-S-z>", "\206\155", {silent = true, noremap = true})
 vim.keymap.set({"n"}, "<C-a>", ":normal i\206\160<cr>", {silent = true, noremap = true})
 vim.keymap.set({"i"}, "<C-a>", "\206\160", {silent = true, noremap = true})




 local function _14_(ev)
 return vim.keymap.del("n", "K", {buffer = ev.buf}) end return vim.api.nvim_create_autocmd("FileType", {pattern = "racket", callback = _14_})
