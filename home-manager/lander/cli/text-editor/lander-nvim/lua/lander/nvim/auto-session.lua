 local auto_session = require("auto-session")

 return auto_session.setup({["single-session-mode"] = true, auto_create = false, auto_restore = false, auto_restore_last_session = false, auto_save = false})