(local which-key (require :which-key))

(which-key.setup {:preset :classic
                  :delay 0
                  :triggers [{1 "<auto>" :mode "nixsotc"}
                             {1 "d" :mode [:n]} 
                             {1 "c" :mode [:n]}
                             {1 "y" :mode [:n]}
                             {1 "f" :mode [:n]}
                             {1 "g" :mode [:n]}
                             {1 "z" :mode [:n]}
                             {1 "m" :mode [:n]}]})
