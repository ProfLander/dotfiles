;; Use Fennel stdio backend by default
(set (. vim :g "conjure#filetype#fennel") "conjure.client.fennel.stdio")

;; Setup stdio command
(set (. vim :g "conjure#client#fennel#stdio#command") "duck-repl")
