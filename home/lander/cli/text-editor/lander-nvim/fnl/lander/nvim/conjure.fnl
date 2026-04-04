;; Use Fennel stdio backend by default
(set (. vim :g "conjure#filetype#fennel") "conjure.client.fennel.stdio")

;; Setup Fennel stdio command
 (set (. vim :g "conjure#client#fennel#stdio#command") "fennel")
; (set (. vim :g "conjure#client#fennel#stdio#command") "duck-repl")

;; Chicken Scheme
(set (. vim :g "conjure#client#scheme#stdio#command") "csi -:c")
(set (. vim :g "conjure#client#scheme#stdio#prompt_pattern") "#;%d>")
(set (. vim :g "conjure#client#scheme#stdio#value_prefix_pattern") false)
