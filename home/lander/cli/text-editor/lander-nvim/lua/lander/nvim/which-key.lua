-- [nfnl] fnl/lander/nvim/which-key.fnl
 local which_key = require("which-key")

 return which_key.setup({preset = "classic", delay = 0, triggers = {{"<auto>", mode = "nixsotc"}, {"d", mode = {"n"}}, {"c", mode = {"n"}}, {"y", mode = {"n"}}, {"f", mode = {"n"}}, {"g", mode = {"n"}}, {"z", mode = {"n"}}, {"m", mode = {"n"}}}})
