-- [nfnl] fnl/lander/nvim/conjure.fnl
 vim["g"]["conjure#filetype#fennel"] = "conjure.client.fennel.stdio"


 local function fennel_path(...) local path = {...} if (nil == path) then _G.error("Missing argument path on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/conjure.fnl:4", 2) else end

 local strs = {"--add-fennel-path", " "}
 for _, str in ipairs(path) do
 table.insert(strs, str) end
 return table.concat(strs) end

 local function macro_path(...) local path = {...} if (nil == path) then _G.error("Missing argument path on /home/lander/dotfiles/home-manager/lander/cli/text-editor/lander-nvim/fnl/lander/nvim/conjure.fnl:11", 2) else end

 local strs = {"--add-macro-path", " "}
 for _, str in ipairs(path) do
 table.insert(strs, str) end
 return table.concat(strs) end local project_dungeon = "/home/lander/src/project-dungeon/"





 vim["g"]["conjure#client#fennel#stdio#command"] = table.concat({"fennel", "--correlate", fennel_path(project_dungeon, "lib/?.fnl"), fennel_path(project_dungeon, "lib/?/init.fnl"), macro_path(project_dungeon, "lib/?.fnlm"), macro_path(project_dungeon, "lib/?/init.fnlm"), fennel_path(project_dungeon, "lib/wak/?.fnl"), fennel_path(project_dungeon, "lib/wak/?/init.fnl"), macro_path(project_dungeon, "lib/wak/?.fnlm"), macro_path(project_dungeon, "lib/wak/?/init.fnlm"), fennel_path(project_dungeon, "lib/duck/?.fnl"), fennel_path(project_dungeon, "lib/duck/?/init.fnl"), macro_path(project_dungeon, "lib/duck/?.fnlm"), macro_path(project_dungeon, "lib/duck/?/init.fnlm")}, " ") return nil
