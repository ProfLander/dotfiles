(require :hotpot)
(local fennel (require :fennel))
(local ts-parsers (require :nvim-treesitter.parsers))

(λ has-parser []
  (ts-parsers.has_parser))

(λ get-parser []
  (ts-parsers.get_parser))

(λ language-for-range [parser [sr sc er ec]]
  (parser:language_for_range [sr sc er ec]))

(λ position->range [[r c]]
  [r c r c])

(λ get-root-for-position [root-lang-tree [r c]]
  (when (has-parser)
    (local ?parser (get-parser))
    (var lang-tree (language-for-range ?parser (position->range [r c])))
    (var out nil)
    (var running true)
    (while running
      (each [_ tree (pairs (lang-tree:trees))]
        (local root (tree:root))
        (when (and root (vim.treesitter.is_in_node_range root r c))
          (set out [root tree lang-tree])
          (set running false)))
      (when (and running (= lang-tree root-lang-tree))
        (set running false))
      (when running
        (set lang-tree (lang-tree:parent))))
    (when (= out nil)
      (set out [nil nil lang-tree]))
    (unpack out)))

(λ named-descendant-for-range [root [sr sc er ec]]
  (root:named_descendant_for_range sr sc er ec))

(λ window->cursor-position [?window]
  (local window (or (and (= (type ?window) :number) ?window) 0))
  (vim.api.nvim_win_get_cursor window))

(λ cursor-position->treesitter-position [[r c]]
  [(- r 1) c])

(λ root-at-cursor [?window]
  (local cursor-position
         (cursor-position->treesitter-position (window->cursor-position ?window)))
  (local cursor-range (position->range cursor-position))
  (local ?parser (get-parser))
  (when ?parser
    (local root-lang-tree (language-for-range ?parser cursor-range))
    (get-root-for-position root-lang-tree cursor-position)))

(λ node-at-cursor [?window]
  (local cursor-position
         (cursor-position->treesitter-position (window->cursor-position ?window)))
  (local ?root (root-at-cursor ?window))
  (when ?root
    (named-descendant-for-range ?root (position->range cursor-position))))

(λ node->range [?node]
  (when ?node [(?node:range)]))

(λ range->vim-range [range ?buf]
  (var [sr sc er ec] range)
  (set sr (+ sr 1))
  (set sc (+ sc 1))
  (set er (+ er 1))
  (when (= ec 0)
    (set er (- er 1))
    (if (or (not ?buf) (= ?buf 0))
        (set ec (- (vim.fn.col [er "$"]) 1))
        (set ec (length (. (vim.api.nvim_buf_get_lines ?buf (- er 1) er false)
                           1))))
    (set ec (math.max ec 1)))
  [sr sc er ec])

(λ node->vim-range [?node ?buf]
  (when ?node
    (range->vim-range (node->range ?node) ?buf)))

(λ node->parent [?node]
  (when ?node (?node:parent))) 

(λ node->tree [?node]
  (when ?node (?node:tree)))

(λ tree->root [?tree]
   (when ?tree (?tree:root)))

(λ node->root [?node]
   (tree->root (node->tree ?node)))

(λ node->parent-unless-root [?node]
  (when ?node
    (local parent (node->parent ?node))
    (local root (node->root ?node))
    (when (not= parent root)
      parent)))

(λ node->?intangible-parent [?node]
  (when ?node
    (local ?next (node->parent ?node))
    (when ?next
      (local [fsr fsc fer fec] (node->vim-range ?node))
      (local [tsr tsc ter tec] (node->vim-range ?next))
      (when (and (= fsr tsr) (= fsc tsc) (= fer ter) (= fec tec))
        ?next))))

(λ repeat [f]
  (λ [?node]
    (λ impl [?node]
      (when ?node
        (local ?next (f ?node))
        (if ?next (impl ?next) ?node)))
    (impl ?node)))

(λ node->named-child [?node i]
  (when ?node (?node:named_child i)))

(λ node->named-child-count [?node]
  (when ?node (?node:named_child_count)))

(λ node-has-named-children? [?node]
   (when ?node
     (local count (node->named-child-count ?node))
     (< 0 count)))

(λ node->named-children [?node]
  (local out [])
  (for [i 0 (- (node->named-child-count ?node) 1)]
    (table.insert out (node->named-child ?node i)))
  out)

(λ node->first-named-child [?node]
  (node->named-child ?node 0))

(λ node->last-named-child [?node]
  (when ?node
    (node->named-child ?node (- (node->named-child-count ?node) 1))))

(λ node->next-named-sibling [?node]
  (when ?node (?node:next_named_sibling)))

(λ node->prev-named-sibling [?node]
  (when ?node (?node:prev_named_sibling)))

(λ node->first-named-sibling [?node]
  (when ?node
    (local ?parent (node->parent ?node))
    (when ?parent
      (node->first-named-child ?parent))))

(λ node->last-named-sibling [?node]
  (when ?node
    (local ?parent (node->parent ?node))
    (when ?parent
      (node->last-named-child ?parent))))

(λ char-at-cursor []
  (local [r c] (window->cursor-position))
  (local [char] (vim.api.nvim_buf_get_text 0 (- r 1) c (- r 1) (+ c 1) {}))
  char)

;; Motions
(λ set-mark [mark]
  (vim.api.nvim_feedkeys (.. :m mark) "" true))

(λ goto-mark [mark]
  (vim.api.nvim_feedkeys (.. "`" mark) "" true))

(λ set-jump []
  (set-mark "'"))

(λ goto-jump []
  (goto-mark "'"))

(λ goto [[r c]]
  (if (= (. (vim.api.nvim_get_mode) :mode) :no)
      (vim.cmd "normal! v"))
  (vim.api.nvim_win_set_cursor (vim.api.nvim_get_current_win) [r (- c 1)]))

(λ range->start-position [[sr sc _er _ec]]
  [sr sc])

(λ range->end-position [[_sr _sc er ec]]
  [er ec])

(λ named-child-ranges [?node]
  (local out [])
  (each [_ child (ipairs (node->named-children ?node))]
    (table.insert out (node->vim-range child)))
  out)

(λ named-child-gaps [?node]
  (when ?node
    (local [nsr nsc _ _] (node->vim-range ?node))
    (local ranges (named-child-ranges ?node))
    (local out [])
    (accumulate [[ar ac] [nsr nsc] _ [csr csc cer cec] (ipairs ranges)]
      (do
        (if (< ar csr)
            (table.insert out [(+ ar 1) 1 csr (- csc 1)])
            (when (< (+ ac 1) csc)
              (table.insert out [ar (+ ac 1) ar (- csc 1)])))
        [cer cec]))
    out))

(λ node->spans [?node]
  (when ?node
    (local spans [])
    (if (node-has-named-children? ?node)
        (do
          (local [nsr nsc ner nec] (node->vim-range ?node))

          (local ?first (node->first-named-child ?node))
          (when ?first
            (local [fsr fsc _ _] (node->vim-range ?first))
            (when (< nsc fsc)
              (table.insert spans [nsr nsc fsr (- fsc 1)])))

          (local child-gaps (named-child-gaps ?node))
          (each [_ gap (ipairs child-gaps)]
            (table.insert spans gap))

          (local ?last (node->last-named-child ?node))
          (when ?last
            (local [_ _ ler lec] (node->vim-range ?last))
            (when (< lec nec)
              (table.insert spans [ler (+ lec 1) ner nec]))))
        (table.insert spans (node->vim-range ?node)))
    spans))

(λ iter-buffer-range [[sr sc er ec] ?buffer]
  (local buffer (or ?buffer 0))
  (values (λ [[_ _ er ec] [r c _]]
            (print sr sc er ec r c)
            (local [text] (vim.api.nvim_buf_get_lines buffer (- r 1) r true))
            (local count (length text))
            (local out (if (< c (or (and (= r er) ec) count)) [r (+ c 1)]
                             (< r er) [(+ r 1) 1]))
            (when out
              (local [r c] out)
              (local [text] (vim.api.nvim_buf_get_lines buffer (- r 1) r true))
              (local t (string.sub text c c))
              [r c t])) [sr sc er ec] [sr (- sc 1)]))

(λ position-within-range? [[r c] [sr sc er ec]]
   (and (<= sr r)
        (<= r er)
        (if (= sr r) (<= sc c) 
            true)
        (if (= er r) (<= c ec)
            true)))

(λ whitespace? [text]
  (or (string.match text "%s+") 
      (= text "")))

(λ non-whitespace? [text]
   (not= (string.match text "[^%s]+") nil))

(λ has-non-whitespace? [?node]
  (when ?node
    (local spans (node->spans ?node))
    (accumulate [non-whitespace false _ [sr sc er ec] (ipairs spans)]
      (do
        (local [text] (vim.api.nvim_buf_get_text 0 (- sr 1) (- sc 1) (- er 1)
                                                 ec {}))
        (or non-whitespace 
            (non-whitespace? text))))))

(λ node->first-non-whitespace [?node]
  (when ?node
    (when (has-non-whitespace? ?node)
      (var out nil)
      (local spans (node->spans ?node))
      (each [_ [sr sc er ec] (ipairs spans)]
        (when (= out nil)
          (local [text]
                 (vim.api.nvim_buf_get_text 0 (- sr 1) (- sc 1) (- er 1) ec {}))
          (when (non-whitespace? text)
            (set out [sr sc]))))
      out)))

(λ node->last-whitespace [?node]
  (when ?node
    (var out nil)
    (local spans (node->spans ?node))
    (each [_ [sr sc er ec] (ipairs spans)]
      (local [text] (vim.api.nvim_buf_get_text 0 (- sr 1) (- sc 1) (- er 1) ec
                                               {}))
      (when (whitespace? text)
        (set out [er ec])))
    out))

(λ whitespace-at-cursor? []
   (local char (char-at-cursor))
   (whitespace? char))

(λ child-in-direction [?fwd?]
  (local fwd? (or ?fwd? false))
  (λ [?node]
    (when ?node
      (when (and (or (and (node-has-named-children? ?node)
                          (has-non-whitespace? ?node))
                     (= ?node (node->root ?node)))
                 (whitespace-at-cursor?))
          (local [r c] (window->cursor-position))
          (local children (node->named-children ?node))
          (var res nil)
          (for [i (or (and fwd? (- (length children) 1)) 0)
                  (or (and fwd? 0)
                      (- (length children) 1)) 
                  (or (and fwd? -1) 1)]
            (local child (node->named-child ?node i))
            (local [csr csc cer cec] (node->vim-range child))
            (when (if fwd?
                      (or (< r csr) (and (= r csr) (< (+ c 1) csc)))
                      (or (< cer r) (and (= r cer) (< cec (+ c 1)))))
              (set res child)))
          res))))

(local node->next-named-child (child-in-direction true))
(local node->prev-named-child (child-in-direction false))

(λ goto-node [?node]
  (when ?node
    (goto (or (node->first-non-whitespace ?node)
              (node->last-whitespace ?node)
              (range->start-position (node->vim-range ?node))))))

(λ goto-node-start [?node]
  (when ?node
    (goto (range->start-position (node->vim-range ?node)))))

(λ goto-node-end [?node]
  (when ?node
    (goto (range->end-position (node->vim-range ?node)))))

;; Text objects
(λ around-node [?node]
  (when ?node
    (goto-node-end ?node)
    (vim.cmd "normal! o")
    (goto-node-start ?node)))

(λ inside-node [?node]
  (when ?node
    (local first-child (node->first-named-child ?node))
    (local last-child (node->last-named-child ?node))
    (when (and first-child last-child)
      (goto-node-end last-child)
      (vim.cmd "normal! o")
      (goto-node-start first-child))))

(λ compose [...]
  (var out nil)
  (each [_ f (ipairs [...])]
    (set out (if out
                 (do
                   (local old-out out)
                   (λ [...]
                     (f (old-out ...))))
                 f)))
  out)

(λ start-insert []
  (vim.cmd :startinsert))

(λ swap-nodes [a b]
  (goto-node-end a)
  (vim.cmd "normal! v")
  (goto-node-start a)
  (vim.cmd "normal! \"ay")
  (goto-node-end b)
  (vim.cmd "normal! v")
  (goto-node-start b)
  (vim.cmd "normal \"by")
  (goto-node-end a)
  (vim.cmd "normal! v")
  (goto-node-start a)
  (vim.cmd "normal! \"bp`[")
  (goto-node-end b)
  (vim.cmd "normal! v")
  (goto-node-start b)
  (vim.cmd "normal! \"ap`["))

(λ try-parse [?range]
  (when (has-parser)
    (local parser (get-parser))
    (parser:parse (or ?range true))))

(λ drag-node-next []
  (local ?node (node-at-cursor))
  (when ?node
    (local ?parent (node->parent ?node))
    (when ?parent
      (local ?sibling (node->next-named-sibling ?node))
      (when ?sibling
        (swap-nodes ?sibling ?node)
        (try-parse)
        (goto-node (node->next-named-sibling (node-at-cursor)))))))

(λ drag-node-prev []
  (local ?node (node-at-cursor))
  (when ?node
    (local ?sibling (node->prev-named-sibling ?node))
    (when ?sibling
      (swap-nodes ?node ?sibling))))

(λ drag-node-up []
  (local ?node (node-at-cursor))
  (when ?node
    (local ?parent (node->parent ?node))
    (when ?parent
      (goto-node-end ?node)
      (vim.cmd "normal! v")
      (goto-node-start ?node)
      (vim.cmd "normal! y")
      (goto-node-end ?parent)
      (vim.cmd "normal! v")
      (goto-node-start ?parent)
      (vim.cmd "normal! p`["))))

(λ update-highlight [ns]
  (λ []
    (try-parse)
    (local ?node (node-at-cursor))
    (when (and ?node (not= ?node (node->root ?node)))
      (local [sr sc er ec] (node->range ?node))
      (vim.api.nvim_set_hl_ns ns)
      (vim.api.nvim_buf_set_extmark 0 ns sr sc
                                    {:id 1
                                     :end_row er
                                     :end_col ec
                                     :hl_group :CurrentNode})
      false)))

(λ register-highlight []
  (local ns (vim.api.nvim_create_namespace :structural-highlight))
  (vim.api.nvim_buf_clear_namespace 0 ns 0 -1)
  (vim.api.nvim_set_hl ns :CurrentNode {:link :CursorLine})
  (vim.api.nvim_create_autocmd :CursorMoved
                               {:group :structural-highlight
                                :callback (update-highlight ns)})
  (vim.api.nvim_create_autocmd :CursorMovedI
                               {:group :structural-highlight
                                :callback (update-highlight ns)})
  (vim.api.nvim_create_autocmd :TextChanged
                               {:group :structural-highlight
                                :callback (update-highlight ns)})
  (vim.api.nvim_create_autocmd :TextChangedI
                               {:group :structural-highlight
                                :callback (update-highlight ns)}))

(λ setup []
  (vim.api.nvim_create_augroup :structural-highlight {})
  (pcall vim.api.nvim_clear_autocmds {:group :structural-highlight})
  (vim.api.nvim_create_autocmd :ColorScheme
                               {:group :structural-highlight
                                :callback register-highlight}))

(λ const [& args]
  (λ []
    (unpack args)))

(λ command [cmd]
  (λ []
    (vim.cmd cmd)))

(λ input [cmd]
  (λ []
    (vim.api.nvim_input cmd)))

(λ push-text [text]
  (λ []
    (vim.cmd (.. "normal i" text))))

(λ insert-text [text]
  (λ []
    (vim.cmd (.. :i text))))

(λ test []
  (print (fennel.view (node->first-non-whitespace (node-at-cursor)))))

(λ node-split-forward [?node]
  (when ?node
    (local ?prev (node->prev-named-sibling ?node))
    (when ?prev
      (local [_ psc _ _] (node->range ?prev))
      (local [sr sc _ _] (node->range ?node))
      (vim.api.nvim_input "fsi<CR><Right><Esc>"))))

(λ node-join-backward [?node]
  (when ?node
    (local ?prev (node->prev-named-sibling ?node))
    (when ?prev
      (local [_ _ er ec] (node->range ?prev))
      (local [sr sc _ _] (node->range ?node))
      (if (< er (- sr 1))
          (vim.api.nvim_buf_set_lines 0
                                     (- sr 1)
                                     sr
                                     true
                                     [])
          (vim.api.nvim_buf_set_text 0 er ec sr sc [" "])))))

(λ node-delete [?node]
  (when ?node
    (local range (node->range ?node))
    (local [sr sc] (range->start-position range))
    (var [er ec] (range->end-position range))
    (local [text] (vim.api.nvim_buf_get_text 0 sr sc er ec {}))
    (local ?next (node->next-named-sibling ?node))
    (when ?next
      (set [er ec] (range->start-position (node->range ?next))))
    (vim.api.nvim_buf_set_text 0 sr sc er ec [""])
    (vim.fn.setreg "+" text)))

(λ node-paste [?backward]
  (local backward (or ?backward false))
  (λ [?node]
    (local [sr sc er ec] (node->range ?node))
    (local ?prev (node->prev-named-sibling ?node))
    (local ?next (node->next-named-sibling ?node))
    (local text (vim.fn.getreg "+"))
    (local replacement (icollect [s (string.gmatch text "[^\n]+")] s))
    (var newlines 0)
    (if ?next
        (do
          (local [nsr _ _ _] (node->range ?next))
          (set newlines (- nsr er)))
        ?prev
        (do
          (local [_ _ ner _] (node->range ?prev))
          (set newlines (- sr ner))))
    (local [fr fc] (if backward [sr sc] [er ec]))
    (local [tr tc] (if backward
                       [sr (or (and (< 0 newlines) ec) sc)]
                       [er (or (and (< 0 newlines) sc) (+ ec 1))]))
    (vim.api.nvim_buf_set_text 0 fr fc fr fc replacement)
    (goto [(+ er 1) (+ ec 1)])
    (if (< 0 newlines) (vim.cmd (.. "normal! i" (string.rep "\r" newlines)))
        (when (< 1 sc) (vim.cmd "normal! i ")))
    (goto [(+ tr (or (and (not backward) newlines) 0) 1) (+ tc 1)])))

(local node-paste-before (node-paste true))
(local node-paste-after (node-paste false))

(λ node-unwrap [?node]
   (when (and ?node (node-has-named-children? ?node))
     (local [sr sc er ec] (node->range ?node))
     (local [fsr fsc _ _] (node->range (node->first-named-child ?node))) 
     (local [_ _ ler lec] (node->range (node->last-named-child ?node)))
     (vim.api.nvim_buf_set_text 0 ler lec er ec [""]) 
     (vim.api.nvim_buf_set_text 0 sr sc fsr fsc [""])))

(λ slurp [?backward]
  (local backward (or ?backward false))
  (λ [?node]
    (when ?node
      (local [sr sc er ec] (node->range ?node))
      (local ?next ((if backward node->prev-named-sibling
                        node->next-named-sibling) ?node))
      (local ?child ((if backward node->first-named-child
                         node->last-named-child) ?node))

      (when ?next
        (local [nsr nsc ner nec] (node->range ?next))
        (var [tr tc] (if backward [nsr nsc] [ner (or (and (= ec nec) (- nec 1)) nec)]))
        (when (and (not backward) (= er tr))
          (set tc (- tc 1)))

        (when (not ?child)
          (local [tsr tsc ter tec] (if backward [ner nec sr sc] [er ec nsr nsc]))
          (vim.api.nvim_buf_set_text 0 tsr tsc ter tec [""])
          (set [tr tc] (if backward [ter tec] [tsr tsc])))

        (local [bsr bsc ber bec]
             (if ?child
                 (do
                   (local [csr csc cer cec] (node->range ?child))
                   (if backward [sr sc csr csc] [cer cec er ec]))
                 (if backward [sr sc sr (+ sc 1)] [er (- ec 1) er ec])))
        (var text (vim.api.nvim_buf_get_text 0 bsr bsc ber bec {}))

        (print bsr bsc ber bec)
        (vim.api.nvim_buf_set_text 0 bsr bsc ber bec [""])
        (vim.api.nvim_buf_set_text 0 tr tc tr tc text)

        (goto [(+ tr 1) (+ tc 1)])))))

(local slurp-prev (slurp true))
(local slurp-next (slurp false))

(λ barf [?backward]
  (local backward (or ?backward false))
  (λ [?node]
    (when (and ?node (node-has-named-children? ?node))
      (local [sr sc er ec] (node->range ?node))
      (local ?next
             ((if backward node->first-named-child node->last-named-child) ?node))
      (local [nsr nsc ner nec] (node->range ?next))
      (local [tsr tsc ter tec] (if backward [sr sc nsr nsc] [ner nec er ec]))
      (local text (vim.api.nvim_buf_get_text 0 tsr tsc ter tec {}))
      (vim.api.nvim_buf_set_text 0 tsr tsc ter tec [""])
      (local ?target ((if backward node->next-named-sibling
                          node->prev-named-sibling) ?next))
      (var [tr tc] (if backward [ner nec] [nsr nsc]))
      (if ?target
          (set [tr tc]
               ((if backward range->start-position range->end-position) (node->range ?target))))
      (when (and backward (= sr tr))
        (set tc (- tc 1)))
      (var [dr dc] [tr tc])
      (when (= (node->named-child-count ?node) 1)
        (if backward
            (do
              (tset text 1 (.. " " (. text 1)))
              (set dc (+ dc 1)))
            (tset text (length text) (.. (. text (length text)) " "))))
      (vim.api.nvim_buf_set_text 0 tr tc tr tc text)
      (goto [(+ dr 1) (+ dc 1)]))))

(local barf-prev (barf true))
(local barf-next (barf false))

(λ otherwise [& fs]
  (λ [...]
    (accumulate [out nil _ f (ipairs fs)]
      (do
        (when (= out nil)
          (local res (f ...)) 
          (when res
            (set out res)))
        out))))

(tset package.loaded :lander.nvim.structural-editing
      {: setup
       : test
       : repeat
       : otherwise
       : node->?intangible-parent
       : node-at-cursor
       : node->parent
       : node->parent-unless-root
       : around-node
       : inside-node
       : goto-node
       : goto-node-start
       : goto-node-end
       : node->first-named-child
       : node->last-named-child
       : node->next-named-child
       : node->prev-named-child
       : node->next-named-sibling
       : node->prev-named-sibling
       : start-insert
       : compose
       : command
       : input
       : const
       : push-text
       : insert-text
       : drag-node-prev
       : drag-node-next
       : drag-node-up
       : node-split-forward
       : node-join-backward
       : slurp-prev
       : slurp-next
       : barf-prev
       : barf-next
       : node-delete
       : node-unwrap
       : node-paste-before
       : node-paste-after
       : update-highlight})
