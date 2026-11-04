local function group(name)
  return vim.api.nvim_create_augroup("dotfiles_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group("highlight_yank"),
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = group("restore_cursor"),
  callback = function(event)
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(event.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group("close_with_q"),
  pattern = {
    "checkhealth",
    "floggraph",
    "fugitive",
    "git",
    "help",
    "lspinfo",
    "man",
    "neotest-output",
    "neotest-summary",
    "notify",
    "opencode_ask",
    "OverseerForm",
    "OverseerList",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "toggleterm",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", {
      buffer = event.buf,
      silent = true,
    })
  end,
})

vim.filetype.add({
  extension = {
    cshtml = "razor",
    mdx = "markdown.mdx",
    razor = "razor",
    templ = "templ",
    tf = "terraform",
    tfvars = "terraform-vars",
  },
  pattern = {
    [".*/%.github/workflows/.*%.yaml"] = "yaml.ghaction",
    [".*/%.github/workflows/.*%.yml"] = "yaml.ghaction",
    [".*%.blade%.php"] = "blade",
  },
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = group("format_options"),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

local function set_winbar_highlights()
  vim.api.nvim_set_hl(0, "WinBar", { link = "Normal" })
  vim.api.nvim_set_hl(0, "WinBarNC", { link = "Comment" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = group("winbar_highlights"),
  callback = set_winbar_highlights,
})

set_winbar_highlights()
