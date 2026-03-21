;; Display relative line numbers
(set vim.o.number true)
(set vim.o.relativenumber true)

;; Use persistent undo history
(set vim.o.undofile true)

;; Display sign column
(set vim.o.signcolumn :yes)

;; Use system clipboard
(set vim.o.clipboard :unnamedplus)

;; Scroll one line / column at a time
(set vim.o.mousescroll "ver:1,hor:1")

;; Disable input timeouts
(set vim.o.timeout false) 
(set vim.o.ttimeout true)

;; Don't wrap lines
(set vim.o.wrap false)

;; Save extended session options
(set vim.o.sessionoptions "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions")

;; Don't use built-in indentation
(set vim.o.smartindent false)

;; Highlight cursor line and column
;(set vim.o.cursorline true)
;(set vim.o.cursorcolumn true)

;; Style the cursor column to match the cursor line
;(vim.api.nvim_set_hl 0 :CursorColumn {:link :CursorLine})
