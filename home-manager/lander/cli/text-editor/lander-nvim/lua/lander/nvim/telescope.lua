-- [nfnl] fnl/lander/nvim/telescope.fnl
 local telescope = require("telescope")
 local actions = require("telescope.actions")

 local delete_buffer_2bmove_to_top = (actions.delete_buffer + actions.move_to_top)

 telescope.setup({defaults = {path_display = {"truncate"}, mappings = {i = {["<C-j>"] = actions.move_selection_next, ["<C-k>"] = actions.move_selection_previous, ["<C-g>"] = actions.close}, n = {["<C-g>"] = actions.close}}}, pickers = {builtin = {theme = "ivy"}, buffers = {theme = "ivy", ignore_current_buffer = true, sort_mru = true, mappings = {i = {["<C-d>"] = delete_buffer_2bmove_to_top}}}, keymaps = {theme = "ivy"}, diagnostics = {theme = "ivy"}, commands = {theme = "ivy"}, help_tags = {theme = "ivy"}, jumplist = {theme = "ivy"}, loclist = {theme = "ivy"}, marks = {theme = "ivy"}, registers = {theme = "ivy"}, vim_options = {theme = "ivy"}, live_grep = {theme = "ivy"}, lsp_definitions = {theme = "ivy"}, lsp_references = {theme = "ivy"}, lsp_incoming_calls = {theme = "ivy"}, lsp_outgoing_calls = {theme = "ivy"}, lsp_implementations = {theme = "ivy"}, lsp_type_definitions = {theme = "ivy"}, lsp_document_symbols = {theme = "ivy"}, lsp_workspace_symbols = {theme = "ivy"}, lsp_dynamic_workspace_symbols = {theme = "ivy"}}})






























 return telescope.load_extension("fzf")
