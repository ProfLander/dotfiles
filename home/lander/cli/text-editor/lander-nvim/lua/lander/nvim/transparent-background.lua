-- [nfnl] fnl/lander/nvim/transparent-background.fnl

 local groups = {"Normal", "NormalNC", "NormalFloat", "FloatBorder", "Pmenu", "SignColumn", "TelescopeNormal"}







 for _, group in ipairs(groups) do
 vim.api.nvim_set_hl(0, group, {bg = "none"}) end return nil
