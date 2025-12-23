(λ sync-broot []
  (local path (vim.api.nvim_buf_get_name 0))
  (when (not= path "")
    (local filename (string.match path "[^/]+$"))
    (when filename
      (local cmd (.. "silent !broot --send main-panel-left --cmd " "\""
                   filename ";"
                   ":select" ";"
                   ":escape" "\""))
      (vim.cmd cmd))
    false))

(pcall vim.api.nvim_clear_autocmds {:group :broot-sync})
(vim.api.nvim_create_augroup :broot-sync {})
(vim.api.nvim_create_autocmd :BufEnter
                             {:group :broot-sync
                              :callback sync-broot})
(vim.api.nvim_create_autocmd :WinEnter
                             {:group :broot-sync
                              :callback sync-broot})
(vim.api.nvim_create_autocmd :TabEnter
                             {:group :broot-sync
                              :callback sync-broot})

(sync-broot)
