require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lsp")
require("config.plugins")

local ok, local_config = pcall(require, "local")
if ok and type(local_config) == "table" and local_config.setup then
  local_config.setup()
end
