 require("hotpot")
 local fennel = require("fennel")
 local ts_parsers = require("nvim-treesitter.parsers")

 local function has_parser()
 return ts_parsers.has_parser() end

 local function get_parser()
 return ts_parsers.get_parser() end

 local function language_for_range(parser, _1_) local sr = _1_[1] local sc = _1_[2] local er = _1_[3] local ec = _1_[4] _G.assert((nil ~= ec), "Missing argument ec on fnl/lander/nvim/structural-editing.fnl:11") _G.assert((nil ~= er), "Missing argument er on fnl/lander/nvim/structural-editing.fnl:11") _G.assert((nil ~= sc), "Missing argument sc on fnl/lander/nvim/structural-editing.fnl:11") _G.assert((nil ~= sr), "Missing argument sr on fnl/lander/nvim/structural-editing.fnl:11") _G.assert((nil ~= parser), "Missing argument parser on fnl/lander/nvim/structural-editing.fnl:11") return parser:language_for_range({sr, sc, er, ec}) end


 local function position__3erange(_2_) local r = _2_[1] local c = _2_[2] _G.assert((nil ~= c), "Missing argument c on fnl/lander/nvim/structural-editing.fnl:14") _G.assert((nil ~= r), "Missing argument r on fnl/lander/nvim/structural-editing.fnl:14")
 return {r, c, r, c} end

 local function get_root_for_position(root_lang_tree, _3_) local r = _3_[1] local c = _3_[2] _G.assert((nil ~= c), "Missing argument c on fnl/lander/nvim/structural-editing.fnl:17") _G.assert((nil ~= r), "Missing argument r on fnl/lander/nvim/structural-editing.fnl:17") _G.assert((nil ~= root_lang_tree), "Missing argument root-lang-tree on fnl/lander/nvim/structural-editing.fnl:17")
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

 local function named_descendant_for_range(root, _9_) local sr = _9_[1] local sc = _9_[2] local er = _9_[3] local ec = _9_[4] _G.assert((nil ~= ec), "Missing argument ec on fnl/lander/nvim/structural-editing.fnl:37") _G.assert((nil ~= er), "Missing argument er on fnl/lander/nvim/structural-editing.fnl:37") _G.assert((nil ~= sc), "Missing argument sc on fnl/lander/nvim/structural-editing.fnl:37") _G.assert((nil ~= sr), "Missing argument sr on fnl/lander/nvim/structural-editing.fnl:37") _G.assert((nil ~= root), "Missing argument root on fnl/lander/nvim/structural-editing.fnl:37") return root:named_descendant_for_range(sr, sc, er, ec) end


 local function window__3ecursor_position(_3fwindow)
 local window = (((type(_3fwindow) == "number") and _3fwindow) or 0)
 return vim.api.nvim_win_get_cursor(window) end

 local function cursor_position__3etreesitter_position(_10_) local r = _10_[1] local c = _10_[2] _G.assert((nil ~= c), "Missing argument c on fnl/lander/nvim/structural-editing.fnl:44") _G.assert((nil ~= r), "Missing argument r on fnl/lander/nvim/structural-editing.fnl:44")
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

 local function range__3evim_range(range, _3fbuf) _G.assert((nil ~= range), "Missing argument range on fnl/lander/nvim/structural-editing.fnl:66")
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
 local _local_22_ = node__3evim_range(_3fnode) local fsr = _local_22_[1] local fsc = _local_22_[2] local fer = _local_22_[3] local fec = _local_22_[4]
 local _local_23_ = node__3evim_range(_3fnext) local tsr = _local_23_[1] local tsc = _local_23_[2] local ter = _local_23_[3] local tec = _local_23_[4]
 if ((fsr == tsr) and (fsc == tsc) and (fer == ter) and (fec == tec)) then
 return _3fnext else return nil end else return nil end else return nil end end

 local function _repeat(f) _G.assert((nil ~= f), "Missing argument f on fnl/lander/nvim/structural-editing.fnl:112")
 local function _27_(_3fnode)
 local function impl(_3fnode0)
 if _3fnode0 then
 local _3fnext = f(_3fnode0)
 if _3fnext then return impl(_3fnext) else return _3fnode0 end else return nil end end
 return impl(_3fnode) end return _27_ end

 local function node__3enamed_child(_3fnode, i) _G.assert((nil ~= i), "Missing argument i on fnl/lander/nvim/structural-editing.fnl:120")
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
 local _local_40_ = window__3ecursor_position() local r = _local_40_[1] local c = _local_40_[2]
 local _local_41_ = vim.api.nvim_buf_get_text(0, (r - 1), c, (r - 1), (c + 1), {}) local char = _local_41_[1]
 return char end


 local function set_mark(mark) _G.assert((nil ~= mark), "Missing argument mark on fnl/lander/nvim/structural-editing.fnl:168")
 return vim.api.nvim_feedkeys(("m" .. mark), "", true) end

 local function goto_mark(mark) _G.assert((nil ~= mark), "Missing argument mark on fnl/lander/nvim/structural-editing.fnl:171")
 return vim.api.nvim_feedkeys(("`" .. mark), "", true) end

 local function set_jump()
 return set_mark("'") end

 local function goto_jump()
 return goto_mark("'") end

 local function _goto(_42_) local r = _42_[1] local c = _42_[2] _G.assert((nil ~= c), "Missing argument c on fnl/lander/nvim/structural-editing.fnl:180") _G.assert((nil ~= r), "Missing argument r on fnl/lander/nvim/structural-editing.fnl:180")
 if (vim.api.nvim_get_mode().mode == "no") then
 vim.cmd("normal! v") else end
 return vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), {r, (c - 1)}) end

 local function range__3estart_position(_44_) local sr = _44_[1] local sc = _44_[2] local _er = _44_[3] local _ec = _44_[4] _G.assert((nil ~= sc), "Missing argument sc on fnl/lander/nvim/structural-editing.fnl:185") _G.assert((nil ~= sr), "Missing argument sr on fnl/lander/nvim/structural-editing.fnl:185")
 return {sr, sc} end

 local function range__3eend_position(_45_) local _sr = _45_[1] local _sc = _45_[2] local er = _45_[3] local ec = _45_[4] _G.assert((nil ~= ec), "Missing argument ec on fnl/lander/nvim/structural-editing.fnl:188") _G.assert((nil ~= er), "Missing argument er on fnl/lander/nvim/structural-editing.fnl:188")
 return {er, ec} end

 local function named_child_ranges(_3fnode)
 local out = {}
 for _, child in ipairs(node__3enamed_children(_3fnode)) do
 table.insert(out, node__3evim_range(child)) end
 return out end

 local function named_child_gaps(_3fnode)
 if _3fnode then
 local _local_46_ = node__3evim_range(_3fnode) local nsr = _local_46_[1] local nsc = _local_46_[2] local _ = _local_46_[3] local _0 = _local_46_[4]
 local ranges = named_child_ranges(_3fnode)
 local out = {}
 do local ar,ac = nsr, nsc for _1, _47_ in ipairs(ranges) do local csr = _47_[1] local csc = _47_[2] local cer = _47_[3] local cec = _47_[4]
 local function _48_()
 if (ar < csr) then
 table.insert(out, {(ar + 1), 1, csr, (csc - 1)}) else
 if ((ac + 1) < csc) then
 table.insert(out, {ar, (ac + 1), ar, (csc - 1)}) else end end
 return {cer, cec} end local _set_51_ = _48_() ar = _set_51_[1] ac = _set_51_[2] end do local _ = {ar, ac} end end
 return out else return nil end end

 local function node__3espans(_3fnode)
 if _3fnode then
 local spans = {}
 if node_has_named_children_3f(_3fnode) then

 local _local_53_ = node__3evim_range(_3fnode) local nsr = _local_53_[1] local nsc = _local_53_[2] local ner = _local_53_[3] local nec = _local_53_[4]

 local _3ffirst = node__3efirst_named_child(_3fnode)
 if _3ffirst then
 local _local_54_ = node__3evim_range(_3ffirst) local fsr = _local_54_[1] local fsc = _local_54_[2] local _ = _local_54_[3] local _0 = _local_54_[4]
 if (nsc < fsc) then
 table.insert(spans, {nsr, nsc, fsr, (fsc - 1)}) else end else end

 local child_gaps = named_child_gaps(_3fnode)
 for _, gap in ipairs(child_gaps) do
 table.insert(spans, gap) end

 local _3flast = node__3elast_named_child(_3fnode)
 if _3flast then
 local _local_57_ = node__3evim_range(_3flast) local _ = _local_57_[1] local _0 = _local_57_[2] local ler = _local_57_[3] local lec = _local_57_[4]
 if (lec < nec) then
 table.insert(spans, {ler, (lec + 1), ner, nec}) else end else end else
 table.insert(spans, node__3evim_range(_3fnode)) end
 return spans else return nil end end

 local function iter_buffer_range(_62_, _3fbuffer) local sr = _62_[1] local sc = _62_[2] local er = _62_[3] local ec = _62_[4] _G.assert((nil ~= ec), "Missing argument ec on fnl/lander/nvim/structural-editing.fnl:236") _G.assert((nil ~= er), "Missing argument er on fnl/lander/nvim/structural-editing.fnl:236") _G.assert((nil ~= sc), "Missing argument sc on fnl/lander/nvim/structural-editing.fnl:236") _G.assert((nil ~= sr), "Missing argument sr on fnl/lander/nvim/structural-editing.fnl:236")
 local buffer = (_3fbuffer or 0)
 local function _65_(_63_, _64_) local _ = _63_[1] local _0 = _63_[2] local er0 = _63_[3] local ec0 = _63_[4] local r = _64_[1] local c = _64_[2] local _1 = _64_[3] _G.assert((nil ~= c), "Missing argument c on fnl/lander/nvim/structural-editing.fnl:238") _G.assert((nil ~= r), "Missing argument r on fnl/lander/nvim/structural-editing.fnl:238") _G.assert((nil ~= ec0), "Missing argument ec on fnl/lander/nvim/structural-editing.fnl:238") _G.assert((nil ~= er0), "Missing argument er on fnl/lander/nvim/structural-editing.fnl:238")
 print(sr, sc, er0, ec0, r, c)
 local _local_66_ = vim.api.nvim_buf_get_lines(buffer, (r - 1), r, true) local text = _local_66_[1]
 local count = #text
 local out if (c < (((r == er0) and ec0) or count)) then out = {r, (c + 1)} elseif (r < er0) then
 out = {(r + 1), 1} else out = nil end
 if out then
 local r0 = out[1] local c0 = out[2]
 local _local_68_ = vim.api.nvim_buf_get_lines(buffer, (r0 - 1), r0, true) local text0 = _local_68_[1]
 local t = string.sub(text0, c0, c0)
 return {r0, c0, t} else return nil end end return _65_, {sr, sc, er, ec}, {sr, (sc - 1)} end

 local function position_within_range_3f(_70_, _71_) local r = _70_[1] local c = _70_[2] local sr = _71_[1] local sc = _71_[2] local er = _71_[3] local ec = _71_[4] _G.assert((nil ~= ec), "Missing argument ec on fnl/lander/nvim/structural-editing.fnl:250") _G.assert((nil ~= er), "Missing argument er on fnl/lander/nvim/structural-editing.fnl:250") _G.assert((nil ~= sc), "Missing argument sc on fnl/lander/nvim/structural-editing.fnl:250") _G.assert((nil ~= sr), "Missing argument sr on fnl/lander/nvim/structural-editing.fnl:250") _G.assert((nil ~= c), "Missing argument c on fnl/lander/nvim/structural-editing.fnl:250") _G.assert((nil ~= r), "Missing argument r on fnl/lander/nvim/structural-editing.fnl:250")
 local and_72_ = (sr <= r) and (r <= er)

 if and_72_ then if (sr == r) then and_72_ = (sc <= c) else and_72_ = true end end

 if and_72_ then if (er == r) then and_72_ = (c <= ec) else and_72_ = true end end return and_72_ end


 local function whitespace_3f(text) _G.assert((nil ~= text), "Missing argument text on fnl/lander/nvim/structural-editing.fnl:258")
 return (string.match(text, "%s+") or (text == "")) end


 local function non_whitespace_3f(text) _G.assert((nil ~= text), "Missing argument text on fnl/lander/nvim/structural-editing.fnl:262")
 return (string.match(text, "[^%s]+") ~= nil) end

 local function has_non_whitespace_3f(_3fnode)
 if _3fnode then
 local spans = node__3espans(_3fnode) local non_whitespace = false
 for _, _75_ in ipairs(spans) do local sr = _75_[1] local sc = _75_[2] local er = _75_[3] local ec = _75_[4]

 local _local_76_ = vim.api.nvim_buf_get_text(0, (sr - 1), (sc - 1), (er - 1), ec, {}) local text = _local_76_[1]

 non_whitespace = (non_whitespace or non_whitespace_3f(text)) end return non_whitespace else return nil end end


 local function node__3efirst_non_whitespace(_3fnode)
 if _3fnode then
 if has_non_whitespace_3f(_3fnode) then
 local out = nil
 local spans = node__3espans(_3fnode)
 for _, _78_ in ipairs(spans) do local sr = _78_[1] local sc = _78_[2] local er = _78_[3] local ec = _78_[4]
 if (out == nil) then
 local _local_79_ = vim.api.nvim_buf_get_text(0, (sr - 1), (sc - 1), (er - 1), ec, {}) local text = _local_79_[1]

 if non_whitespace_3f(text) then
 out = {sr, sc} else end else end end
 return out else return nil end else return nil end end

 local function node__3elast_whitespace(_3fnode)
 if _3fnode then
 local out = nil
 local spans = node__3espans(_3fnode)
 for _, _84_ in ipairs(spans) do local sr = _84_[1] local sc = _84_[2] local er = _84_[3] local ec = _84_[4]
 local _local_85_ = vim.api.nvim_buf_get_text(0, (sr - 1), (sc - 1), (er - 1), ec, {}) local text = _local_85_[1]

 if whitespace_3f(text) then
 out = {er, ec} else end end
 return out else return nil end end

 local function whitespace_at_cursor_3f()
 local char = char_at_cursor()
 return whitespace_3f(char) end

 local function child_in_direction(_3ffwd_3f)
 local fwd_3f = (_3ffwd_3f or false)
 local function _88_(_3fnode)
 if _3fnode then
 if (((node_has_named_children_3f(_3fnode) and has_non_whitespace_3f(_3fnode)) or (_3fnode == node__3eroot(_3fnode))) and whitespace_at_cursor_3f()) then



 local _local_89_ = window__3ecursor_position() local r = _local_89_[1] local c = _local_89_[2]
 local children = node__3enamed_children(_3fnode)
 local res = nil
 for i = ((fwd_3f and (#children - 1)) or 0), ((fwd_3f and 0) or (#children - 1)), ((fwd_3f and -1) or 1) do



 local child = node__3enamed_child(_3fnode, i)
 local _local_90_ = node__3evim_range(child) local csr = _local_90_[1] local csc = _local_90_[2] local cer = _local_90_[3] local cec = _local_90_[4]
 local _91_ if fwd_3f then
 _91_ = ((r < csr) or ((r == csr) and ((c + 1) < csc))) else
 _91_ = ((cer < r) or ((r == cer) and (cec < (c + 1)))) end if _91_ then
 res = child else end end
 return res else return nil end else return nil end end return _88_ end

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
 local function _102_(...)
 return f(old_out(...)) end out = _102_ else
 out = f end end
 return out end

 local function start_insert()
 return vim.cmd("startinsert") end

 local function swap_nodes(a, b) _G.assert((nil ~= b), "Missing argument b on fnl/lander/nvim/structural-editing.fnl:373") _G.assert((nil ~= a), "Missing argument a on fnl/lander/nvim/structural-editing.fnl:373")
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

 local function update_highlight(ns) _G.assert((nil ~= ns), "Missing argument ns on fnl/lander/nvim/structural-editing.fnl:428")
 local function _112_()
 try_parse()
 local _3fnode = node_at_cursor()
 if (_3fnode and (_3fnode ~= node__3eroot(_3fnode))) then
 local _local_113_ = node__3erange(_3fnode) local sr = _local_113_[1] local sc = _local_113_[2] local er = _local_113_[3] local ec = _local_113_[4]
 vim.api.nvim_set_hl_ns(ns)
 vim.api.nvim_buf_set_extmark(0, ns, sr, sc, {id = 1, end_row = er, end_col = ec, hl_group = "CurrentNode"}) return false else return nil end end return _112_ end






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



 local function const(...) local args = {...} _G.assert((nil ~= args), "Missing argument args on fnl/lander/nvim/structural-editing.fnl:466")
 local function _115_()
 return unpack(args) end return _115_ end

 local function command(cmd) _G.assert((nil ~= cmd), "Missing argument cmd on fnl/lander/nvim/structural-editing.fnl:470")
 local function _116_()
 return vim.cmd(cmd) end return _116_ end

 local function input(cmd) _G.assert((nil ~= cmd), "Missing argument cmd on fnl/lander/nvim/structural-editing.fnl:474")
 local function _117_()
 return vim.api.nvim_input(cmd) end return _117_ end

 local function push_text(text) _G.assert((nil ~= text), "Missing argument text on fnl/lander/nvim/structural-editing.fnl:478")
 local function _118_()
 return vim.cmd(("normal i" .. text)) end return _118_ end

 local function insert_text(text) _G.assert((nil ~= text), "Missing argument text on fnl/lander/nvim/structural-editing.fnl:482")
 local function _119_()
 return vim.cmd(("i" .. text)) end return _119_ end

 local function test()
 return print(fennel.view(node__3efirst_non_whitespace(node_at_cursor()))) end

 local function node_split_forward(_3fnode)
 if _3fnode then
 local _3fprev = node__3eprev_named_sibling(_3fnode)
 if _3fprev then
 local _local_120_ = node__3erange(_3fprev) local _ = _local_120_[1] local psc = _local_120_[2] local _0 = _local_120_[3] local _1 = _local_120_[4]
 local _local_121_ = node__3erange(_3fnode) local sr = _local_121_[1] local sc = _local_121_[2] local _2 = _local_121_[3] local _3 = _local_121_[4]
 return vim.api.nvim_input("fsi<CR><Right><Esc>") else return nil end else return nil end end

 local function node_join_backward(_3fnode)
 if _3fnode then
 local _3fprev = node__3eprev_named_sibling(_3fnode)
 if _3fprev then
 local _local_124_ = node__3erange(_3fprev) local _ = _local_124_[1] local _0 = _local_124_[2] local er = _local_124_[3] local ec = _local_124_[4]
 local _local_125_ = node__3erange(_3fnode) local sr = _local_125_[1] local sc = _local_125_[2] local _1 = _local_125_[3] local _2 = _local_125_[4]
 if (er < (sr - 1)) then
 return vim.api.nvim_buf_set_lines(0, (sr - 1), sr, true, {}) else




 return vim.api.nvim_buf_set_text(0, er, ec, sr, sc, {" "}) end else return nil end else return nil end end

 local function node_delete(_3fnode)
 if _3fnode then
 local range = node__3erange(_3fnode)
 local _local_129_ = range__3estart_position(range) local sr = _local_129_[1] local sc = _local_129_[2]
 local _var_130_ = range__3eend_position(range) local er = _var_130_[1] local ec = _var_130_[2]
 local _local_131_ = vim.api.nvim_buf_get_text(0, sr, sc, er, ec, {}) local text = _local_131_[1]
 local _3fnext = node__3enext_named_sibling(_3fnode)
 if _3fnext then
 local _set_132_ = range__3estart_position(node__3erange(_3fnext)) er = _set_132_[1] ec = _set_132_[2] else end
 vim.api.nvim_buf_set_text(0, sr, sc, er, ec, {""})
 return vim.fn.setreg("+", text) else return nil end end

 local function node_paste(_3fbackward)
 local backward = (_3fbackward or false)
 local function _135_(_3fnode)
 local _local_136_ = node__3erange(_3fnode) local sr = _local_136_[1] local sc = _local_136_[2] local er = _local_136_[3] local ec = _local_136_[4]
 local _3fprev = node__3eprev_named_sibling(_3fnode)
 local _3fnext = node__3enext_named_sibling(_3fnode)
 local text = vim.fn.getreg("+")
 local replacement do local tbl_21_ = {} local i_22_ = 0 for s in string.gmatch(text, "[^\n]+") do local val_23_ = s if (nil ~= val_23_) then i_22_ = (i_22_ + 1) tbl_21_[i_22_] = val_23_ else end end replacement = tbl_21_ end local newlines = 0

 if _3fnext then

 local _local_138_ = node__3erange(_3fnext) local nsr = _local_138_[1] local _ = _local_138_[2] local _0 = _local_138_[3] local _1 = _local_138_[4]
 newlines = (nsr - er) elseif _3fprev then


 local _local_139_ = node__3erange(_3fprev) local _ = _local_139_[1] local _0 = _local_139_[2] local ner = _local_139_[3] local _1 = _local_139_[4]
 newlines = (sr - ner) else end
 local function _141_() if backward then return {sr, sc} else return {er, ec} end end local _local_142_ = _141_() local fr = _local_142_[1] local fc = _local_142_[2]
 local function _143_() if backward then
 return {sr, (((0 < newlines) and ec) or sc)} else
 return {er, (((0 < newlines) and sc) or (ec + 1))} end end local _local_144_ = _143_() local tr = _local_144_[1] local tc = _local_144_[2]
 vim.api.nvim_buf_set_text(0, fr, fc, fr, fc, replacement)
 _goto({(er + 1), (ec + 1)})
 if (0 < newlines) then vim.cmd(("normal! i" .. string.rep("\r", newlines))) else
 if (1 < sc) then vim.cmd("normal! i ") else end end
 return _goto({(tr + ((not backward and newlines) or 0) + 1), (tc + 1)}) end return _135_ end

 local node_paste_before = node_paste(true)
 local node_paste_after = node_paste(false)

 local function node_unwrap(_3fnode)
 if (_3fnode and node_has_named_children_3f(_3fnode)) then
 local _local_147_ = node__3erange(_3fnode) local sr = _local_147_[1] local sc = _local_147_[2] local er = _local_147_[3] local ec = _local_147_[4]
 local _local_148_ = node__3erange(node__3efirst_named_child(_3fnode)) local fsr = _local_148_[1] local fsc = _local_148_[2] local _ = _local_148_[3] local _0 = _local_148_[4]
 local _local_149_ = node__3erange(node__3elast_named_child(_3fnode)) local _1 = _local_149_[1] local _2 = _local_149_[2] local ler = _local_149_[3] local lec = _local_149_[4]
 vim.api.nvim_buf_set_text(0, ler, lec, er, ec, {""})
 return vim.api.nvim_buf_set_text(0, sr, sc, fsr, fsc, {""}) else return nil end end

 local function slurp(_3fbackward)
 local backward = (_3fbackward or false)
 local function _151_(_3fnode)
 if _3fnode then
 local _local_152_ = node__3erange(_3fnode) local sr = _local_152_[1] local sc = _local_152_[2] local er = _local_152_[3] local ec = _local_152_[4]
 local _3fnext local _153_ if backward then _153_ = node__3eprev_named_sibling else
 _153_ = node__3enext_named_sibling end _3fnext = _153_(_3fnode)
 local _3fchild local _155_ if backward then _155_ = node__3efirst_named_child else
 _155_ = node__3elast_named_child end _3fchild = _155_(_3fnode)

 if _3fnext then
 local _local_157_ = node__3erange(_3fnext) local nsr = _local_157_[1] local nsc = _local_157_[2] local ner = _local_157_[3] local nec = _local_157_[4]
 local function _158_() if backward then return {nsr, nsc} else return {ner, (((ec == nec) and (nec - 1)) or nec)} end end local _var_159_ = _158_() local tr = _var_159_[1] local tc = _var_159_[2]
 if (not backward and (er == tr)) then
 tc = (tc - 1) else end

 if not _3fchild then
 local function _161_() if backward then return {ner, nec, sr, sc} else return {er, ec, nsr, nsc} end end local _local_162_ = _161_() local tsr = _local_162_[1] local tsc = _local_162_[2] local ter = _local_162_[3] local tec = _local_162_[4]
 vim.api.nvim_buf_set_text(0, tsr, tsc, ter, tec, {""})
 local function _163_() if backward then return {ter, tec} else return {tsr, tsc} end end local _set_164_ = _163_() tr = _set_164_[1] tc = _set_164_[2] else end


 local function _169_() if _3fchild then

 local _local_166_ = node__3erange(_3fchild) local csr = _local_166_[1] local csc = _local_166_[2] local cer = _local_166_[3] local cec = _local_166_[4]
 if backward then return {sr, sc, csr, csc} else return {cer, cec, er, ec} end else
 if backward then return {sr, sc, sr, (sc + 1)} else return {er, (ec - 1), er, ec} end end end local _local_170_ = _169_() local bsr = _local_170_[1] local bsc = _local_170_[2] local ber = _local_170_[3] local bec = _local_170_[4]
 local text = vim.api.nvim_buf_get_text(0, bsr, bsc, ber, bec, {})

 print(bsr, bsc, ber, bec)
 vim.api.nvim_buf_set_text(0, bsr, bsc, ber, bec, {""})
 vim.api.nvim_buf_set_text(0, tr, tc, tr, tc, text)

 return _goto({(tr + 1), (tc + 1)}) else return nil end else return nil end end return _151_ end

 local slurp_prev = slurp(true)
 local slurp_next = slurp(false)

 local function barf(_3fbackward)
 local backward = (_3fbackward or false)
 local function _173_(_3fnode)
 if (_3fnode and node_has_named_children_3f(_3fnode)) then
 local _local_174_ = node__3erange(_3fnode) local sr = _local_174_[1] local sc = _local_174_[2] local er = _local_174_[3] local ec = _local_174_[4]
 local _3fnext
 local _175_ if backward then _175_ = node__3efirst_named_child else _175_ = node__3elast_named_child end _3fnext = _175_(_3fnode)
 local _local_177_ = node__3erange(_3fnext) local nsr = _local_177_[1] local nsc = _local_177_[2] local ner = _local_177_[3] local nec = _local_177_[4]
 local function _178_() if backward then return {sr, sc, nsr, nsc} else return {ner, nec, er, ec} end end local _local_179_ = _178_() local tsr = _local_179_[1] local tsc = _local_179_[2] local ter = _local_179_[3] local tec = _local_179_[4]
 local text = vim.api.nvim_buf_get_text(0, tsr, tsc, ter, tec, {})
 vim.api.nvim_buf_set_text(0, tsr, tsc, ter, tec, {""})
 local _3ftarget local _180_ if backward then _180_ = node__3enext_named_sibling else
 _180_ = node__3eprev_named_sibling end _3ftarget = _180_(_3fnext)
 local function _182_() if backward then return {ner, nec} else return {nsr, nsc} end end local _var_183_ = _182_() local tr = _var_183_[1] local tc = _var_183_[2]
 if _3ftarget then

 local _184_ if backward then _184_ = range__3estart_position else _184_ = range__3eend_position end local _set_186_ = _184_(node__3erange(_3ftarget)) tr = _set_186_[1] tc = _set_186_[2] else end
 if (backward and (sr == tr)) then
 tc = (tc - 1) else end local dr,dc = tr, tc

 if (node__3enamed_child_count(_3fnode) == 1) then
 if backward then

 text[1] = (" " .. text[1])
 dc = (dc + 1) else
 text[#text] = (text[#text] .. " ") end else end
 vim.api.nvim_buf_set_text(0, tr, tc, tr, tc, text)
 return _goto({(dr + 1), (dc + 1)}) else return nil end end return _173_ end

 local barf_prev = barf(true)
 local barf_next = barf(false)

 local function otherwise(...) local fs = {...} _G.assert((nil ~= fs), "Missing argument fs on fnl/lander/nvim/structural-editing.fnl:631")
 local function _192_(...)
 local out = nil for _, f in ipairs(fs) do

 if (out == nil) then
 local res = f(...)
 if res then
 out = res else end else end
 out = out end return out end return _192_ end

 package.loaded["lander.nvim.structural-editing"] = {setup = setup, test = test, ["repeat"] = _repeat, otherwise = otherwise, ["node->?intangible-parent"] = node__3e_3fintangible_parent, ["node-at-cursor"] = node_at_cursor, ["node->parent"] = node__3eparent, ["node->parent-unless-root"] = node__3eparent_unless_root, ["around-node"] = around_node, ["inside-node"] = inside_node, ["goto-node"] = goto_node, ["goto-node-start"] = goto_node_start, ["goto-node-end"] = goto_node_end, ["node->first-named-child"] = node__3efirst_named_child, ["node->last-named-child"] = node__3elast_named_child, ["node->next-named-child"] = node__3enext_named_child, ["node->prev-named-child"] = node__3eprev_named_child, ["node->next-named-sibling"] = node__3enext_named_sibling, ["node->prev-named-sibling"] = node__3eprev_named_sibling, ["start-insert"] = start_insert, compose = compose, command = command, input = input, const = const, ["push-text"] = push_text, ["insert-text"] = insert_text, ["drag-node-prev"] = drag_node_prev, ["drag-node-next"] = drag_node_next, ["drag-node-up"] = drag_node_up, ["node-split-forward"] = node_split_forward, ["node-join-backward"] = node_join_backward, ["slurp-prev"] = slurp_prev, ["slurp-next"] = slurp_next, ["barf-prev"] = barf_prev, ["barf-next"] = barf_next, ["node-delete"] = node_delete, ["node-unwrap"] = node_unwrap, ["node-paste-before"] = node_paste_before, ["node-paste-after"] = node_paste_after, ["update-highlight"] = update_highlight} return nil