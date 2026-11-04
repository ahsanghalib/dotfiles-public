if vim.fn.has("nvim-0.12") ~= 1 then
  error("This configuration requires Neovim 0.12 or newer")
end

vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.conoline_auto_enable = 1
vim.g.markdown_recommended_style = 0

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy-setup")
