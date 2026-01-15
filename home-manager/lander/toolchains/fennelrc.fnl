(set _G.fennel (require :fennel))

;; persist repl history
(case package.loaded.readline
  rl (rl.set_options {:histfile  "~/.fennel_history"
                      :keeplines 1000}))
