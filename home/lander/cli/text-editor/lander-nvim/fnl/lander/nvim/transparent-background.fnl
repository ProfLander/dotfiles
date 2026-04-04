(local groups 
  ["Normal"
   "NormalNC"
   "NormalFloat"
   "FloatBorder"
   "Pmenu"
   "SignColumn"
   "TelescopeNormal"])

(each [_ group (ipairs groups)]
  (vim.api.nvim_set_hl 0 group {:bg :none}))
