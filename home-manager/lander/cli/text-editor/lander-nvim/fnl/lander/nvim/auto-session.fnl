(local auto-session (require :auto-session))

(auto-session.setup {:auto_save false
                     :auto_restore false
                     :auto_create false
                     :auto_restore_last_session false
                     :single-session-mode true})
