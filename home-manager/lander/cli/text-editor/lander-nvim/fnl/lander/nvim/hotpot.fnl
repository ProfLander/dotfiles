(local hotpot (require :hotpot))

(hotpot.setup {
  ;; disable auto-injected diagnostics which conflict with LSP
  :enable_hotpot_diagnostics false
})
