-- [nfnl] fnl/lander/nvim/structural-editing.fnl
 require("hotpot")
 local fennel = require("fennel")
 local ts_parsers = require("nvim-treesitter.parsers")

 local function has_parser()
 return ts_parsers.has_parser() end

 local function get_parser()
 return ts_parsers.get_parser() end

 local function language_for_range(parser, _1_) local sr = _1_[1] local sc = _1_[2] local er = _1_[3] local ec = _1_[4] if (nil == ec) then _G.error("Missing argument ec on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:11", 2) else end if (nil == er) then _G.error("Missing argument er on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:11", 2) else end if (nil == sc) then _G.error("Missing argument sc on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:11", 2) else end if (nil == sr) then _G.error("Missing argument sr on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:11", 2) else end if (nil == parser) then _G.error("Missing argument parser on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:11", 2) else end return parser:language_for_range({sr, sc, er, ec}) end


 local function position__3erange(_7_) local r = _7_[1] local c = _7_[2] if (nil == c) then _G.error("Missing argument c on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:14", 2) else end if (nil == r) then _G.error("Missing argument r on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:14", 2) else end
 return {r, c, r, c} end

 local function get_root_for_position(root_lang_tree, _10_) local r = _10_[1] local c = _10_[2] if (nil == c) then _G.error("Missing argument c on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:17", 2) else end if (nil == r) then _G.error("Missing argument r on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:17", 2) else end if (nil == root_lang_tree) then _G.error("Missing argument root-lang-tree on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:17", 2) else end
 if has_parser() then
 local _3fparser = get_parser()
 local lang_tree = language_for_range(_3fparser, position__3erange({r, c}))
 local out = nil local running = true

 while running do
 for _, tree in pairs(lang_tree:trees()) do local root = tree:root()

 if (root and vim.treesitter.is_in_node_range(root, r, c)) then
 out = {root, tree, lang_tree} running = false else end end

 if (running and (lang_tree == root_lang_tree)) then running = false else end

 if running then lang_tree = lang_tree:parent() else end end

 if (out == nil) then
 out = {nil, nil, lang_tree} else end
 return unpack(out) else return nil end end

 local function named_descendant_for_range(root, _19_) local sr = _19_[1] local sc = _19_[2] local er = _19_[3] local ec = _19_[4] if (nil == ec) then _G.error("Missing argument ec on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:37", 2) else end if (nil == er) then _G.error("Missing argument er on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:37", 2) else end if (nil == sc) then _G.error("Missing argument sc on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:37", 2) else end if (nil == sr) then _G.error("Missing argument sr on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:37", 2) else end if (nil == root) then _G.error("Missing argument root on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:37", 2) else end return root:named_descendant_for_range(sr, sc, er, ec) end


 local function window__3ecursor_position(_3fwindow)
 local window = (((type(_3fwindow) == "number") and _3fwindow) or 0)
 return vim.api.nvim_win_get_cursor(window) end

 local function cursor_position__3etreesitter_position(_25_) local r = _25_[1] local c = _25_[2] if (nil == c) then _G.error("Missing argument c on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:44", 2) else end if (nil == r) then _G.error("Missing argument r on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:44", 2) else end
 return {(r - 1), c} end

 local function root_at_cursor(_3fwindow)

 local cursor_position = cursor_position__3etreesitter_position(window__3ecursor_position(_3fwindow))
 local cursor_range = position__3erange(cursor_position)
 local _3fparser = get_parser()
 if _3fparser then
 local root_lang_tree = language_for_range(_3fparser, cursor_range)
 return get_root_for_position(root_lang_tree, cursor_position) else return nil end end

 local function node_at_cursor(_3fwindow)

 local cursor_position = cursor_position__3etreesitter_position(window__3ecursor_position(_3fwindow))
 local _3froot = root_at_cursor(_3fwindow)
 if _3froot then
 return named_descendant_for_range(_3froot, position__3erange(cursor_position)) else return nil end end

 local function node__3erange(_3fnode)
 if _3fnode then return {_3fnode:range()} else return nil end end

 local function range__3evim_range(range, _3fbuf) if (nil == range) then _G.error("Missing argument range on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:66", 2) else end
 local sr = range[1] local sc = range[2] local er = range[3] local ec = range[4]
 sr = (sr + 1)
 sc = (sc + 1)
 er = (er + 1)
 if (ec == 0) then
 er = (er - 1)
 if (not _3fbuf or (_3fbuf == 0)) then
 ec = (vim.fn.col({er, "$"}) - 1) else
 ec = #vim.api.nvim_buf_get_lines(_3fbuf, (er - 1), er, false)[1] end

 ec = math.max(ec, 1) else end
 return {sr, sc, er, ec} end

 local function node__3evim_range(_3fnode, _3fbuf)
 if _3fnode then
 return range__3evim_range(node__3erange(_3fnode), _3fbuf) else return nil end end

 local function node__3eparent(_3fnode)
 if _3fnode then return _3fnode:parent() else return nil end end

 local function node__3etree(_3fnode)
 if _3fnode then return _3fnode:tree() else return nil end end

 local function tree__3eroot(_3ftree)
 if _3ftree then return _3ftree:root() else return nil end end

 local function node__3eroot(_3fnode)
 return tree__3eroot(node__3etree(_3fnode)) end

 local function node__3eparent_unless_root(_3fnode)
 if _3fnode then
 local parent = node__3eparent(_3fnode)
 local root = node__3eroot(_3fnode)
 if (parent ~= root) then
 return parent else return nil end else return nil end end

 local function node__3e_3fintangible_parent(_3fnode)
 if _3fnode then
 local _3fnext = node__3eparent(_3fnode)
 if _3fnext then
 local _local_40_ = node__3evim_range(_3fnode) local fsr = _local_40_[1] local fsc = _local_40_[2] local fer = _local_40_[3] local fec = _local_40_[4]
 local _local_41_ = node__3evim_range(_3fnext) local tsr = _local_41_[1] local tsc = _local_41_[2] local ter = _local_41_[3] local tec = _local_41_[4]
 if ((fsr == tsr) and (fsc == tsc) and (fer == ter) and (fec == tec)) then
 return _3fnext else return nil end else return nil end else return nil end end

 local function _repeat(f) if (nil == f) then _G.error("Missing argument f on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:112", 2) else end
 local function _46_(_3fnode)
 local function impl(_3fnode0)
 if _3fnode0 then
 local _3fnext = f(_3fnode0)
 if _3fnext then return impl(_3fnext) else return _3fnode0 end else return nil end end
 return impl(_3fnode) end return _46_ end

 local function node__3enamed_child(_3fnode, i) if (nil == i) then _G.error("Missing argument i on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:120", 2) else end
 if _3fnode then return _3fnode:named_child(i) else return nil end end

 local function node__3enamed_child_count(_3fnode)
 if _3fnode then return _3fnode:named_child_count() else return nil end end

 local function node_has_named_children_3f(_3fnode)
 if _3fnode then
 local count = node__3enamed_child_count(_3fnode)
 return (0 < count) else return nil end end

 local function node__3enamed_children(_3fnode)
 local out = {}
 for i = 0, (node__3enamed_child_count(_3fnode) - 1) do
 table.insert(out, node__3enamed_child(_3fnode, i)) end
 return out end

 local function node__3efirst_named_child(_3fnode)
 return node__3enamed_child(_3fnode, 0) end

 local function node__3elast_named_child(_3fnode)
 if _3fnode then
 return node__3enamed_child(_3fnode, (node__3enamed_child_count(_3fnode) - 1)) else return nil end end

 local function node__3enext_named_sibling(_3fnode)
 if _3fnode then return _3fnode:next_named_sibling() else return nil end end

 local function node__3eprev_named_sibling(_3fnode)
 if _3fnode then return _3fnode:prev_named_sibling() else return nil end end

 local function node__3efirst_named_sibling(_3fnode)
 if _3fnode then
 local _3fparent = node__3eparent(_3fnode)
 if _3fparent then
 return node__3efirst_named_child(_3fparent) else return nil end else return nil end end

 local function node__3elast_named_sibling(_3fnode)
 if _3fnode then
 local _3fparent = node__3eparent(_3fnode)
 if _3fparent then
 return node__3elast_named_child(_3fparent) else return nil end else return nil end end

 local function char_at_cursor()
 local _local_60_ = window__3ecursor_position() local r = _local_60_[1] local c = _local_60_[2]
 local _local_61_ = vim.api.nvim_buf_get_text(0, (r - 1), c, (r - 1), (c + 1), {}) local char = _local_61_[1]
 return char end


 local function set_mark(mark) if (nil == mark) then _G.error("Missing argument mark on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:168", 2) else end
 return vim.api.nvim_feedkeys(("m" .. mark), "", true) end

 local function goto_mark(mark) if (nil == mark) then _G.error("Missing argument mark on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:171", 2) else end
 return vim.api.nvim_feedkeys(("`" .. mark), "", true) end

 local function set_jump()
 return set_mark("'") end

 local function goto_jump()
 return goto_mark("'") end

 local function _goto(_64_) local r = _64_[1] local c = _64_[2] if (nil == c) then _G.error("Missing argument c on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:180", 2) else end if (nil == r) then _G.error("Missing argument r on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:180", 2) else end
 if (vim.api.nvim_get_mode().mode == "no") then
 vim.cmd("normal! v") else end
 return vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), {r, (c - 1)}) end

 local function range__3estart_position(_68_) local sr = _68_[1] local sc = _68_[2] local _er = _68_[3] local _ec = _68_[4] if (nil == sc) then _G.error("Missing argument sc on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:185", 2) else end if (nil == sr) then _G.error("Missing argument sr on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:185", 2) else end
 return {sr, sc} end

 local function range__3eend_position(_71_) local _sr = _71_[1] local _sc = _71_[2] local er = _71_[3] local ec = _71_[4] if (nil == ec) then _G.error("Missing argument ec on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:188", 2) else end if (nil == er) then _G.error("Missing argument er on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:188", 2) else end
 return {er, ec} end

 local function named_child_ranges(_3fnode)
 local out = {}
 for _, child in ipairs(node__3enamed_children(_3fnode)) do
 table.insert(out, node__3evim_range(child)) end
 return out end

 local function named_child_gaps(_3fnode)
 if _3fnode then
 local _local_74_ = node__3evim_range(_3fnode) local nsr = _local_74_[1] local nsc = _local_74_[2] local _ = _local_74_[3] local _0 = _local_74_[4]
 local ranges = named_child_ranges(_3fnode)
 local out = {}
 do local ar,ac = nsr, nsc for _1, _75_ in ipairs(ranges) do local csr = _75_[1] local csc = _75_[2] local cer = _75_[3] local cec = _75_[4]
 local function _76_()
 if (ar < csr) then
 table.insert(out, {(ar + 1), 1, csr, (csc - 1)}) else
 if ((ac + 1) < csc) then
 table.insert(out, {ar, (ac + 1), ar, (csc - 1)}) else end end
 return {cer, cec} end local _set_79_ = _76_() ar = _set_79_[1] ac = _set_79_[2] end do local _ = {ar, ac} end end
 return out else return nil end end

 local function node__3espans(_3fnode)
 if _3fnode then
 local spans = {}
 if node_has_named_children_3f(_3fnode) then

 local _local_81_ = node__3evim_range(_3fnode) local nsr = _local_81_[1] local nsc = _local_81_[2] local ner = _local_81_[3] local nec = _local_81_[4]

 local _3ffirst = node__3efirst_named_child(_3fnode)
 if _3ffirst then
 local _local_82_ = node__3evim_range(_3ffirst) local fsr = _local_82_[1] local fsc = _local_82_[2] local _ = _local_82_[3] local _0 = _local_82_[4]
 if (nsc < fsc) then
 table.insert(spans, {nsr, nsc, fsr, (fsc - 1)}) else end else end

 local child_gaps = named_child_gaps(_3fnode)
 for _, gap in ipairs(child_gaps) do
 table.insert(spans, gap) end

 local _3flast = node__3elast_named_child(_3fnode)
 if _3flast then
 local _local_85_ = node__3evim_range(_3flast) local _ = _local_85_[1] local _0 = _local_85_[2] local ler = _local_85_[3] local lec = _local_85_[4]
 if (lec < nec) then
 table.insert(spans, {ler, (lec + 1), ner, nec}) else end else end else
 table.insert(spans, node__3evim_range(_3fnode)) end
 return spans else return nil end end

 local function iter_buffer_range(_90_, _3fbuffer) local sr = _90_[1] local sc = _90_[2] local er = _90_[3] local ec = _90_[4] if (nil == ec) then _G.error("Missing argument ec on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:236", 2) else end if (nil == er) then _G.error("Missing argument er on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:236", 2) else end if (nil == sc) then _G.error("Missing argument sc on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:236", 2) else end if (nil == sr) then _G.error("Missing argument sr on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:236", 2) else end
 local buffer = (_3fbuffer or 0)
 local function _97_(_95_, _96_) local _ = _95_[1] local _0 = _95_[2] local er0 = _95_[3] local ec0 = _95_[4] local r = _96_[1] local c = _96_[2] local _1 = _96_[3] if (nil == c) then _G.error("Missing argument c on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:238", 2) else end if (nil == r) then _G.error("Missing argument r on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:238", 2) else end if (nil == ec0) then _G.error("Missing argument ec on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:238", 2) else end if (nil == er0) then _G.error("Missing argument er on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:238", 2) else end
 print(sr, sc, er0, ec0, r, c)
 local _local_102_ = vim.api.nvim_buf_get_lines(buffer, (r - 1), r, true) local text = _local_102_[1]
 local count = #text
 local out if (c < (((r == er0) and ec0) or count)) then out = {r, (c + 1)} elseif (r < er0) then
 out = {(r + 1), 1} else out = nil end
 if out then
 local r0 = out[1] local c0 = out[2]
 local _local_104_ = vim.api.nvim_buf_get_lines(buffer, (r0 - 1), r0, true) local text0 = _local_104_[1]
 local t = string.sub(text0, c0, c0)
 return {r0, c0, t} else return nil end end return _97_, {sr, sc, er, ec}, {sr, (sc - 1)} end

 local function position_within_range_3f(_106_, _107_) local r = _106_[1] local c = _106_[2] local sr = _107_[1] local sc = _107_[2] local er = _107_[3] local ec = _107_[4] if (nil == ec) then _G.error("Missing argument ec on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:250", 2) else end if (nil == er) then _G.error("Missing argument er on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:250", 2) else end if (nil == sc) then _G.error("Missing argument sc on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:250", 2) else end if (nil == sr) then _G.error("Missing argument sr on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:250", 2) else end if (nil == c) then _G.error("Missing argument c on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:250", 2) else end if (nil == r) then _G.error("Missing argument r on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:250", 2) else end
 local and_114_ = (sr <= r) and (r <= er)

 if and_114_ then if (sr == r) then and_114_ = (sc <= c) else and_114_ = true end end

 if and_114_ then if (er == r) then and_114_ = (c <= ec) else and_114_ = true end end return and_114_ end


 local function whitespace_3f(text) if (nil == text) then _G.error("Missing argument text on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:258", 2) else end
 return (string.match(text, "%s+") or (text == "")) end


 local function non_whitespace_3f(text) if (nil == text) then _G.error("Missing argument text on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:262", 2) else end
 return (string.match(text, "[^%s]+") ~= nil) end

 local function has_non_whitespace_3f(_3fnode)
 if _3fnode then
 local spans = node__3espans(_3fnode) local non_whitespace = false
 for _, _119_ in ipairs(spans) do local sr = _119_[1] local sc = _119_[2] local er = _119_[3] local ec = _119_[4]

 local _local_120_ = vim.api.nvim_buf_get_text(0, (sr - 1), (sc - 1), (er - 1), ec, {}) local text = _local_120_[1]

 non_whitespace = (non_whitespace or non_whitespace_3f(text)) end return non_whitespace else return nil end end


 local function node__3efirst_non_whitespace(_3fnode)
 if _3fnode then
 if has_non_whitespace_3f(_3fnode) then
 local out = nil
 local spans = node__3espans(_3fnode)
 for _, _122_ in ipairs(spans) do local sr = _122_[1] local sc = _122_[2] local er = _122_[3] local ec = _122_[4]
 if (out == nil) then
 local _local_123_ = vim.api.nvim_buf_get_text(0, (sr - 1), (sc - 1), (er - 1), ec, {}) local text = _local_123_[1]

 if non_whitespace_3f(text) then
 out = {sr, sc} else end else end end
 return out else return nil end else return nil end end

 local function node__3elast_whitespace(_3fnode)
 if _3fnode then
 local out = nil
 local spans = node__3espans(_3fnode)
 for _, _128_ in ipairs(spans) do local sr = _128_[1] local sc = _128_[2] local er = _128_[3] local ec = _128_[4]
 local _local_129_ = vim.api.nvim_buf_get_text(0, (sr - 1), (sc - 1), (er - 1), ec, {}) local text = _local_129_[1]

 if whitespace_3f(text) then
 out = {er, ec} else end end
 return out else return nil end end

 local function whitespace_at_cursor_3f()
 local char = char_at_cursor()
 return whitespace_3f(char) end

 local function child_in_direction(_3ffwd_3f)
 local fwd_3f = (_3ffwd_3f or false)
 local function _132_(_3fnode)
 if _3fnode then
 if (((node_has_named_children_3f(_3fnode) and has_non_whitespace_3f(_3fnode)) or (_3fnode == node__3eroot(_3fnode))) and whitespace_at_cursor_3f()) then



 local _local_133_ = window__3ecursor_position() local r = _local_133_[1] local c = _local_133_[2]
 local children = node__3enamed_children(_3fnode)
 local res = nil
 for i = ((fwd_3f and (#children - 1)) or 0), ((fwd_3f and 0) or (#children - 1)), ((fwd_3f and -1) or 1) do



 local child = node__3enamed_child(_3fnode, i)
 local _local_134_ = node__3evim_range(child) local csr = _local_134_[1] local csc = _local_134_[2] local cer = _local_134_[3] local cec = _local_134_[4]
 local _135_ if fwd_3f then
 _135_ = ((r < csr) or ((r == csr) and ((c + 1) < csc))) else
 _135_ = ((cer < r) or ((r == cer) and (cec < (c + 1)))) end if _135_ then
 res = child else end end
 return res else return nil end else return nil end end return _132_ end

 local node__3enext_named_child = child_in_direction(true)
 local node__3eprev_named_child = child_in_direction(false)

 local function goto_node(_3fnode)
 if _3fnode then
 return _goto((node__3efirst_non_whitespace(_3fnode) or node__3elast_whitespace(_3fnode) or range__3estart_position(node__3evim_range(_3fnode)))) else return nil end end



 local function goto_node_start(_3fnode)
 if _3fnode then
 return _goto(range__3estart_position(node__3evim_range(_3fnode))) else return nil end end

 local function goto_node_end(_3fnode)
 if _3fnode then
 return _goto(range__3eend_position(node__3evim_range(_3fnode))) else return nil end end


 local function around_node(_3fnode)
 if _3fnode then
 goto_node_end(_3fnode)
 vim.cmd("normal! o")
 return goto_node_start(_3fnode) else return nil end end

 local function inside_node(_3fnode)
 if _3fnode then
 local first_child = node__3efirst_named_child(_3fnode)
 local last_child = node__3elast_named_child(_3fnode)
 if (first_child and last_child) then
 goto_node_end(last_child)
 vim.cmd("normal! o")
 return goto_node_start(first_child) else return nil end else return nil end end

 local function compose(...)
 local out = nil
 for _, f in ipairs({...}) do
 if out then

 local old_out = out
 local function _146_(...)
 return f(old_out(...)) end out = _146_ else
 out = f end end
 return out end

 local function start_insert()
 return vim.cmd("startinsert") end

 local function swap_nodes(a, b) if (nil == b) then _G.error("Missing argument b on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:373", 2) else end if (nil == a) then _G.error("Missing argument a on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:373", 2) else end
 goto_node_end(a)
 vim.cmd("normal! v")
 goto_node_start(a)
 vim.cmd("normal! \"ay")
 goto_node_end(b)
 vim.cmd("normal! v")
 goto_node_start(b)
 vim.cmd("normal \"by")
 goto_node_end(a)
 vim.cmd("normal! v")
 goto_node_start(a)
 vim.cmd("normal! \"bp`[")
 goto_node_end(b)
 vim.cmd("normal! v")
 goto_node_start(b)
 return vim.cmd("normal! \"ap`[") end

 local function try_parse(_3frange)
 if has_parser() then
 local parser = get_parser() return parser:parse((_3frange or true)) else return nil end end


 local function drag_node_next()
 local _3fnode = node_at_cursor()
 if _3fnode then
 local _3fparent = node__3eparent(_3fnode)
 if _3fparent then
 local _3fsibling = node__3enext_named_sibling(_3fnode)
 if _3fsibling then
 swap_nodes(_3fsibling, _3fnode)
 try_parse()
 return goto_node(node__3enext_named_sibling(node_at_cursor())) else return nil end else return nil end else return nil end end

 local function drag_node_prev()
 local _3fnode = node_at_cursor()
 if _3fnode then
 local _3fsibling = node__3eprev_named_sibling(_3fnode)
 if _3fsibling then
 return swap_nodes(_3fnode, _3fsibling) else return nil end else return nil end end

 local function drag_node_up()
 local _3fnode = node_at_cursor()
 if _3fnode then
 local _3fparent = node__3eparent(_3fnode)
 if _3fparent then
 goto_node_end(_3fnode)
 vim.cmd("normal! v")
 goto_node_start(_3fnode)
 vim.cmd("normal! y")
 goto_node_end(_3fparent)
 vim.cmd("normal! v")
 goto_node_start(_3fparent)
 return vim.cmd("normal! p`[") else return nil end else return nil end end

 local function update_highlight(ns) if (nil == ns) then _G.error("Missing argument ns on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:428", 2) else end
 local function _159_()
 try_parse()
 local _3fnode = node_at_cursor()
 if (_3fnode and (_3fnode ~= node__3eroot(_3fnode))) then
 local _local_160_ = node__3erange(_3fnode) local sr = _local_160_[1] local sc = _local_160_[2] local er = _local_160_[3] local ec = _local_160_[4]
 vim.api.nvim_set_hl_ns(ns)
 vim.api.nvim_buf_set_extmark(0, ns, sr, sc, {id = 1, end_row = er, end_col = ec, hl_group = "CurrentNode"}) return false else return nil end end return _159_ end






 local function register_highlight()
 local ns = vim.api.nvim_create_namespace("structural-highlight")
 vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
 vim.api.nvim_set_hl(ns, "CurrentNode", {link = "CursorLine"})
 vim.api.nvim_create_autocmd("CursorMoved", {group = "structural-highlight", callback = update_highlight(ns)})


 vim.api.nvim_create_autocmd("CursorMovedI", {group = "structural-highlight", callback = update_highlight(ns)})


 vim.api.nvim_create_autocmd("TextChanged", {group = "structural-highlight", callback = update_highlight(ns)})


 return vim.api.nvim_create_autocmd("TextChangedI", {group = "structural-highlight", callback = update_highlight(ns)}) end



 local function setup()
 vim.api.nvim_create_augroup("structural-highlight", {})
 pcall(vim.api.nvim_clear_autocmds, {group = "structural-highlight"})
 return vim.api.nvim_create_autocmd("ColorScheme", {group = "structural-highlight", callback = register_highlight}) end



 local function const(...) local args = {...} if (nil == args) then _G.error("Missing argument args on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:466", 2) else end
 local function _163_()
 return unpack(args) end return _163_ end

 local function command(cmd) if (nil == cmd) then _G.error("Missing argument cmd on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:470", 2) else end
 local function _165_()
 return vim.cmd(cmd) end return _165_ end

 local function input(cmd) if (nil == cmd) then _G.error("Missing argument cmd on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:474", 2) else end
 local function _167_()
 return vim.api.nvim_input(cmd) end return _167_ end

 local function push_text(text) if (nil == text) then _G.error("Missing argument text on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:478", 2) else end
 local function _169_()
 return vim.cmd(("normal i" .. text)) end return _169_ end

 local function insert_text(text) if (nil == text) then _G.error("Missing argument text on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:482", 2) else end
 local function _171_()
 return vim.cmd(("i" .. text)) end return _171_ end

 local function test()
 return print(fennel.view(node__3efirst_non_whitespace(node_at_cursor()))) end

 local function node_split_forward(_3fnode)
 if _3fnode then
 local _3fprev = node__3eprev_named_sibling(_3fnode)
 if _3fprev then
 local _local_172_ = node__3erange(_3fprev) local _ = _local_172_[1] local psc = _local_172_[2] local _0 = _local_172_[3] local _1 = _local_172_[4]
 local _local_173_ = node__3erange(_3fnode) local sr = _local_173_[1] local sc = _local_173_[2] local _2 = _local_173_[3] local _3 = _local_173_[4]
 return vim.api.nvim_input("fsi<CR><Right><Esc>") else return nil end else return nil end end

 local function node_join_backward(_3fnode)
 if _3fnode then
 local _3fprev = node__3eprev_named_sibling(_3fnode)
 if _3fprev then
 local _local_176_ = node__3erange(_3fprev) local _ = _local_176_[1] local _0 = _local_176_[2] local er = _local_176_[3] local ec = _local_176_[4]
 local _local_177_ = node__3erange(_3fnode) local sr = _local_177_[1] local sc = _local_177_[2] local _1 = _local_177_[3] local _2 = _local_177_[4]
 if (er < (sr - 1)) then
 return vim.api.nvim_buf_set_lines(0, (sr - 1), sr, true, {}) else




 return vim.api.nvim_buf_set_text(0, er, ec, sr, sc, {" "}) end else return nil end else return nil end end

 local function node_delete(_3fnode)
 if _3fnode then
 local range = node__3erange(_3fnode)
 local _local_181_ = range__3estart_position(range) local sr = _local_181_[1] local sc = _local_181_[2]
 local _var_182_ = range__3eend_position(range) local er = _var_182_[1] local ec = _var_182_[2]
 local _local_183_ = vim.api.nvim_buf_get_text(0, sr, sc, er, ec, {}) local text = _local_183_[1]
 local _3fnext = node__3enext_named_sibling(_3fnode)
 if _3fnext then
 local _set_184_ = range__3estart_position(node__3erange(_3fnext)) er = _set_184_[1] ec = _set_184_[2] else end
 vim.api.nvim_buf_set_text(0, sr, sc, er, ec, {""})
 return vim.fn.setreg("+", text) else return nil end end

 local function node_paste(_3fbackward)
 local backward = (_3fbackward or false)
 local function _187_(_3fnode)
 local _local_188_ = node__3erange(_3fnode) local sr = _local_188_[1] local sc = _local_188_[2] local er = _local_188_[3] local ec = _local_188_[4]
 local _3fprev = node__3eprev_named_sibling(_3fnode)
 local _3fnext = node__3enext_named_sibling(_3fnode)
 local text = vim.fn.getreg("+")
 local replacement do local tbl_26_ = {} local i_27_ = 0 for s in string.gmatch(text, "[^\n]+") do local val_28_ = s if (nil ~= val_28_) then i_27_ = (i_27_ + 1) tbl_26_[i_27_] = val_28_ else end end replacement = tbl_26_ end local newlines = 0

 if _3fnext then

 local _local_190_ = node__3erange(_3fnext) local nsr = _local_190_[1] local _ = _local_190_[2] local _0 = _local_190_[3] local _1 = _local_190_[4]
 newlines = (nsr - er) elseif _3fprev then


 local _local_191_ = node__3erange(_3fprev) local _ = _local_191_[1] local _0 = _local_191_[2] local ner = _local_191_[3] local _1 = _local_191_[4]
 newlines = (sr - ner) else end
 local function _193_() if backward then return {sr, sc} else return {er, ec} end end local _local_194_ = _193_() local fr = _local_194_[1] local fc = _local_194_[2]
 local function _195_() if backward then
 return {sr, (((0 < newlines) and ec) or sc)} else
 return {er, (((0 < newlines) and sc) or (ec + 1))} end end local _local_196_ = _195_() local tr = _local_196_[1] local tc = _local_196_[2]
 vim.api.nvim_buf_set_text(0, fr, fc, fr, fc, replacement)
 _goto({(er + 1), (ec + 1)})
 if (0 < newlines) then vim.cmd(("normal! i" .. string.rep("\r", newlines))) else
 if (1 < sc) then vim.cmd("normal! i ") else end end
 return _goto({(tr + ((not backward and newlines) or 0) + 1), (tc + 1)}) end return _187_ end

 local node_paste_before = node_paste(true)
 local node_paste_after = node_paste(false)

 local function node_unwrap(_3fnode)
 if (_3fnode and node_has_named_children_3f(_3fnode)) then
 local _local_199_ = node__3erange(_3fnode) local sr = _local_199_[1] local sc = _local_199_[2] local er = _local_199_[3] local ec = _local_199_[4]
 local _local_200_ = node__3erange(node__3efirst_named_child(_3fnode)) local fsr = _local_200_[1] local fsc = _local_200_[2] local _ = _local_200_[3] local _0 = _local_200_[4]
 local _local_201_ = node__3erange(node__3elast_named_child(_3fnode)) local _1 = _local_201_[1] local _2 = _local_201_[2] local ler = _local_201_[3] local lec = _local_201_[4]
 vim.api.nvim_buf_set_text(0, ler, lec, er, ec, {""})
 return vim.api.nvim_buf_set_text(0, sr, sc, fsr, fsc, {""}) else return nil end end

 local function slurp(_3fbackward)
 local backward = (_3fbackward or false)
 local function _203_(_3fnode)
 if _3fnode then
 local _local_204_ = node__3erange(_3fnode) local sr = _local_204_[1] local sc = _local_204_[2] local er = _local_204_[3] local ec = _local_204_[4]
 local _3fnext local _205_ if backward then _205_ = node__3eprev_named_sibling else
 _205_ = node__3enext_named_sibling end _3fnext = _205_(_3fnode)
 local _3fchild local _207_ if backward then _207_ = node__3efirst_named_child else
 _207_ = node__3elast_named_child end _3fchild = _207_(_3fnode)

 if _3fnext then
 local _local_209_ = node__3erange(_3fnext) local nsr = _local_209_[1] local nsc = _local_209_[2] local ner = _local_209_[3] local nec = _local_209_[4]
 local function _210_() if backward then return {nsr, nsc} else return {ner, (((ec == nec) and (nec - 1)) or nec)} end end local _var_211_ = _210_() local tr = _var_211_[1] local tc = _var_211_[2]
 if (not backward and (er == tr)) then
 tc = (tc - 1) else end

 if not _3fchild then
 local function _213_() if backward then return {ner, nec, sr, sc} else return {er, ec, nsr, nsc} end end local _local_214_ = _213_() local tsr = _local_214_[1] local tsc = _local_214_[2] local ter = _local_214_[3] local tec = _local_214_[4]
 vim.api.nvim_buf_set_text(0, tsr, tsc, ter, tec, {""})
 local function _215_() if backward then return {ter, tec} else return {tsr, tsc} end end local _set_216_ = _215_() tr = _set_216_[1] tc = _set_216_[2] else end


 local function _221_() if _3fchild then

 local _local_218_ = node__3erange(_3fchild) local csr = _local_218_[1] local csc = _local_218_[2] local cer = _local_218_[3] local cec = _local_218_[4]
 if backward then return {sr, sc, csr, csc} else return {cer, cec, er, ec} end else
 if backward then return {sr, sc, sr, (sc + 1)} else return {er, (ec - 1), er, ec} end end end local _local_222_ = _221_() local bsr = _local_222_[1] local bsc = _local_222_[2] local ber = _local_222_[3] local bec = _local_222_[4]
 local text = vim.api.nvim_buf_get_text(0, bsr, bsc, ber, bec, {})

 print(bsr, bsc, ber, bec)
 vim.api.nvim_buf_set_text(0, bsr, bsc, ber, bec, {""})
 vim.api.nvim_buf_set_text(0, tr, tc, tr, tc, text)

 return _goto({(tr + 1), (tc + 1)}) else return nil end else return nil end end return _203_ end

 local slurp_prev = slurp(true)
 local slurp_next = slurp(false)

 local function barf(_3fbackward)
 local backward = (_3fbackward or false)
 local function _225_(_3fnode)
 if (_3fnode and node_has_named_children_3f(_3fnode)) then
 local _local_226_ = node__3erange(_3fnode) local sr = _local_226_[1] local sc = _local_226_[2] local er = _local_226_[3] local ec = _local_226_[4]
 local _3fnext
 local _227_ if backward then _227_ = node__3efirst_named_child else _227_ = node__3elast_named_child end _3fnext = _227_(_3fnode)
 local _local_229_ = node__3erange(_3fnext) local nsr = _local_229_[1] local nsc = _local_229_[2] local ner = _local_229_[3] local nec = _local_229_[4]
 local function _230_() if backward then return {sr, sc, nsr, nsc} else return {ner, nec, er, ec} end end local _local_231_ = _230_() local tsr = _local_231_[1] local tsc = _local_231_[2] local ter = _local_231_[3] local tec = _local_231_[4]
 local text = vim.api.nvim_buf_get_text(0, tsr, tsc, ter, tec, {})
 vim.api.nvim_buf_set_text(0, tsr, tsc, ter, tec, {""})
 local _3ftarget local _232_ if backward then _232_ = node__3enext_named_sibling else
 _232_ = node__3eprev_named_sibling end _3ftarget = _232_(_3fnext)
 local function _234_() if backward then return {ner, nec} else return {nsr, nsc} end end local _var_235_ = _234_() local tr = _var_235_[1] local tc = _var_235_[2]
 if _3ftarget then

 local _236_ if backward then _236_ = range__3estart_position else _236_ = range__3eend_position end local _set_238_ = _236_(node__3erange(_3ftarget)) tr = _set_238_[1] tc = _set_238_[2] else end
 if (backward and (sr == tr)) then
 tc = (tc - 1) else end local dr,dc = tr, tc

 if (node__3enamed_child_count(_3fnode) == 1) then
 if backward then

 text[1] = (" " .. text[1])
 dc = (dc + 1) else
 text[#text] = (text[#text] .. " ") end else end
 vim.api.nvim_buf_set_text(0, tr, tc, tr, tc, text)
 return _goto({(dr + 1), (dc + 1)}) else return nil end end return _225_ end

 local barf_prev = barf(true)
 local barf_next = barf(false)

 local function otherwise(...) local fs = {...} if (nil == fs) then _G.error("Missing argument fs on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/structural-editing.fnl:631", 2) else end
 local function _245_(...)
 local out = nil for _, f in ipairs(fs) do

 if (out == nil) then
 local res = f(...)
 if res then
 out = res else end else end
 out = out end return out end return _245_ end

 package.loaded["lander.nvim.structural-editing"] = {setup = setup, test = test, ["repeat"] = _repeat, otherwise = otherwise, ["node->?intangible-parent"] = node__3e_3fintangible_parent, ["node-at-cursor"] = node_at_cursor, ["node->parent"] = node__3eparent, ["node->parent-unless-root"] = node__3eparent_unless_root, ["around-node"] = around_node, ["inside-node"] = inside_node, ["goto-node"] = goto_node, ["goto-node-start"] = goto_node_start, ["goto-node-end"] = goto_node_end, ["node->first-named-child"] = node__3efirst_named_child, ["node->last-named-child"] = node__3elast_named_child, ["node->next-named-child"] = node__3enext_named_child, ["node->prev-named-child"] = node__3eprev_named_child, ["node->next-named-sibling"] = node__3enext_named_sibling, ["node->prev-named-sibling"] = node__3eprev_named_sibling, ["start-insert"] = start_insert, compose = compose, command = command, input = input, const = const, ["push-text"] = push_text, ["insert-text"] = insert_text, ["drag-node-prev"] = drag_node_prev, ["drag-node-next"] = drag_node_next, ["drag-node-up"] = drag_node_up, ["node-split-forward"] = node_split_forward, ["node-join-backward"] = node_join_backward, ["slurp-prev"] = slurp_prev, ["slurp-next"] = slurp_next, ["barf-prev"] = barf_prev, ["barf-next"] = barf_next, ["node-delete"] = node_delete, ["node-unwrap"] = node_unwrap, ["node-paste-before"] = node_paste_before, ["node-paste-after"] = node_paste_after, ["update-highlight"] = update_highlight} return nil
