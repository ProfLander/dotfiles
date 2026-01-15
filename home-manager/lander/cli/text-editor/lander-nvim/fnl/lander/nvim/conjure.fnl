;; Use Fennel stdio backend by default
(set (. vim :g "conjure#filetype#fennel") "conjure.client.fennel.stdio")

(λ fennel-path [& path]
  "Assemble an --add-fennel-path argument "
  (local strs ["--add-fennel-path" " "])
  (each [_ str (ipairs path)]
    (table.insert strs str))
  (table.concat strs))

(λ macro-path [& path]
  "Assemble an --add-macro-path argument "
  (local strs ["--add-macro-path" " "])
  (each [_ str (ipairs path)]
    (table.insert strs str))
  (table.concat strs))

(local project-dungeon "/home/lander/src/project-dungeon/")

;; Setup stdio command
(set (. vim :g "conjure#client#fennel#stdio#command") 
  (table.concat 
    ["fennel" 

     ;; Enable line number correlation
     "--correlate"

     ;; Setup standard import paths
     (fennel-path project-dungeon "lib/?.fnl")
     (fennel-path project-dungeon "lib/?/init.fnl")
     (macro-path project-dungeon "lib/?.fnlm")
     (macro-path project-dungeon "lib/?/init.fnlm")

     (fennel-path project-dungeon "lib/wak/?.fnl")
     (fennel-path project-dungeon "lib/wak/?/init.fnl")
     (macro-path project-dungeon "lib/wak/?.fnlm")
     (macro-path project-dungeon "lib/wak/?/init.fnlm")

     (fennel-path project-dungeon "lib/duck/?.fnl")
     (fennel-path project-dungeon "lib/duck/?/init.fnl")
     (macro-path project-dungeon "lib/duck/?.fnlm")
     (macro-path project-dungeon "lib/duck/?/init.fnlm")]
    " "))
