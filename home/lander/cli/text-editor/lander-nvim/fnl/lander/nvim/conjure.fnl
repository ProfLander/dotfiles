;; Don't autostart REPL on opening a file
(set (. vim :g "conjure#client_on_load") false)

;; Don't override C-k with eval-current-form
(set (. vim :g "conjure#mapping#doc_word") false)

;; Override racket prompt parser to handle <pkgs> prefix
(set (. vim :g "conjure#client#racket#stdio#prompt_pattern")
     "\n?[<>\"%w%-./_]*> ")

;; Use Fennel stdio backend by default
(set (. vim :g "conjure#filetype#fennel") "conjure.client.fennel.stdio")

;; Setup Fennel stdio command
 (set (. vim :g "conjure#client#fennel#stdio#command") "fennel")

;; Chicken Scheme
(set (. vim :g "conjure#client#scheme#stdio#command") "csi -:c")
(set (. vim :g "conjure#client#scheme#stdio#prompt_pattern") "#;%d>")
(set (. vim :g "conjure#client#scheme#stdio#value_prefix_pattern") false)
