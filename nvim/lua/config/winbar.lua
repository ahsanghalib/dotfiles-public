local M = {}

function M.render()
  if vim.bo.buftype ~= "" then
    return ""
  end

  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    return "[No Name]"
  end

  local path = vim.fn.fnamemodify(name, ":~:.")
  local max_width = math.max(20, math.floor(vim.api.nvim_win_get_width(0) * 0.65))
  if vim.fn.strdisplaywidth(path) > max_width then
    path = vim.fn.pathshorten(path)
  end

  local flags = {}
  if vim.bo.modified then
    flags[#flags + 1] = "[+]"
  end
  if vim.bo.readonly or not vim.bo.modifiable then
    flags[#flags + 1] = "[RO]"
  end

  path = path:gsub("%%", "%%%%")
  return (#flags > 0 and table.concat(flags, " ") .. " " or "") .. path
end

return M
