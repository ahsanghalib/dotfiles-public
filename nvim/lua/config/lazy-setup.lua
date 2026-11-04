local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazy_path) then
  local result = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazy_path,
  })
  if vim.v.shell_error ~= 0 then
    error("Failed to install lazy.nvim:\n" .. result)
  end
end

vim.opt.rtp:prepend(lazy_path)

require("lazy").setup("plugins", {
  change_detection = { notify = false },
  checker = {
    enabled = vim.env.NVIM_SKIP_TOOL_INSTALL ~= "1",
    frequency = 86400,
    notify = false,
  },
  defaults = { lazy = true, version = false },
  install = {},
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
      },
    },
  },
  rocks = { enabled = false },
  ui = { border = "rounded" },
})
