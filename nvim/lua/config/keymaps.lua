local map = vim.keymap.set

map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("t", "jk", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

for _, direction in ipairs({ "h", "j", "k", "l" }) do
  map("n", "<C-" .. direction .. ">", "<C-w>" .. direction, {
    desc = "Focus " .. direction .. " window",
  })
  map("t", "<C-" .. direction .. ">", "<C-\\><C-n><C-w>" .. direction)
end

map("n", "<leader>nh", "<cmd>nohlsearch<cr>", { desc = "Clear search" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Diagnostic float" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostic location list" })
map("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic" })
map("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })

map("n", "<leader>wv", "<C-w>v", { desc = "Vertical split" })
map("n", "<leader>wh", "<C-w>s", { desc = "Horizontal split" })
map("n", "<leader>we", "<C-w>=", { desc = "Equal splits" })
map("n", "<leader>wx", "<cmd>close<cr>", { desc = "Close split" })

map("n", "<leader>to", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader>tx", "<cmd>tabclose<cr>", { desc = "Close tab" })
map("n", "<leader>tn", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<leader>tp", "<cmd>tabprevious<cr>", { desc = "Previous tab" })
map("n", "<leader>tf", "<cmd>tabnew %<cr>", { desc = "Buffer in new tab" })

map("n", "<leader>bx", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "g,", "g,zvzz")
map("n", "g;", "g;zvzz")
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

map("n", "x", '"_x', { desc = "Delete character without yank" })
map("v", "<leader>d", '"_d', { desc = "Delete without yank" })
map("x", "<leader>p", '"_dP', { desc = "Paste without replacing register" })
map("v", "p", '"_dp', { desc = "Paste without replacing register" })
map("v", "J", ":move '>+1<cr>gv=gv", { silent = true })
map("v", "K", ":move '<-2<cr>gv=gv", { silent = true })
map("v", "<", "<gv")
map("v", ">", ">gv")

map("n", "]p", "o<Esc>p", { desc = "Paste below" })
map("n", "]P", "O<Esc>p", { desc = "Paste above" })
map("n", "]<Space>", "o<Esc>", { desc = "Blank line below" })
map("n", "[<Space>", "O<Esc>", { desc = "Blank line above" })

map("n", "<leader>+", "<C-a>", { desc = "Increment" })
map("n", "<leader>-", "<C-x>", { desc = "Decrement" })
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {
  desc = "Replace word under cursor",
})

map("n", "<leader>co", "<cmd>copen<cr>", { desc = "Open quickfix" })
map("n", "<leader>cc", "<cmd>cclose<cr>", { desc = "Close quickfix" })
map("n", "<leader>cx", "<cmd>call setqflist([], 'r')<cr>", {
  desc = "Clear quickfix",
})
map("n", "<leader>k", "<cmd>lnext<cr>zz", { desc = "Next location item" })
map("n", "<leader>j", "<cmd>lprevious<cr>zz", { desc = "Previous location item" })

for _, key in ipairs({ ",", ".", ";" }) do
  map("i", key, key .. "<C-g>u", { desc = "Insert " .. key .. " with undo break" })
end

map("n", "i", function()
  return #vim.fn.getline(".") == 0 and '"_cc' or "i"
end, { expr = true, desc = "Insert without carrying indentation on blank lines" })

map("n", "K", function()
  local clients = vim.lsp.get_clients({
    bufnr = 0,
    method = "textDocument/hover",
  })

  if #clients > 0 then
    vim.lsp.buf.hover({ border = "rounded" })
    return
  end

  local ok, ufo = pcall(require, "ufo")
  if ok and ufo.peekFoldedLinesUnderCursor() then
    return
  end

  vim.cmd("normal! K")
end, { desc = "LSP hover, folded preview, or keyword help" })
