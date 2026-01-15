{;; Only compile files in the `fnl` directory
 :source-file-patterns ["fnl/**/*.fnl"]
 :compiler-options {;; Disable ANSI escape codes in compiler output
                    :error-pinpoint false
                    ;; Enable line correlation for more specific error reporting
                    :correlate true}}
