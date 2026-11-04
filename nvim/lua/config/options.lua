local opt = vim.opt

opt.autoindent = true
opt.background = "dark"
opt.backspace = "indent,eol,start"
opt.breakindent = true
opt.clipboard = { "unnamed", "unnamedplus" }
opt.cmdheight = 0
opt.completeopt = { "menu", "menuone", "noselect" }
opt.conceallevel = 0
opt.confirm = true
opt.cursorline = true
opt.expandtab = true
opt.fileencoding = "utf-8"
opt.fillchars = {
  eob = " ",
  fold = " ",
  foldclose = "",
  foldopen = "",
  foldsep = " ",
}
opt.foldcolumn = "1"
opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.formatoptions = "jqlnt"
opt.hidden = true
opt.hlsearch = true
opt.ignorecase = true
opt.inccommand = "nosplit"
opt.joinspaces = false
opt.laststatus = 3
opt.linebreak = true
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.mouse = "a"
opt.number = true
opt.pumblend = 10
opt.pumheight = 10
opt.relativenumber = true
opt.scrollback = 100000
opt.scrolloff = 8
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shiftround = true
opt.shiftwidth = 2
opt.shortmess:append({ C = true, I = true, W = true, c = true })
opt.showcmd = false
opt.showmode = false
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.swapfile = false
opt.tabstop = 2
opt.termguicolors = true
opt.textwidth = 120
opt.timeoutlen = 300
opt.title = true
opt.undofile = true
opt.updatetime = 200
opt.wildmode = "longest:full,full"
opt.wrap = true
opt.winbar = "%=%{%v:lua.require'config.winbar'.render()%}"

local state = vim.fn.stdpath("state")
opt.undodir = state .. "/undo//"

vim.fn.mkdir(state .. "/undo", "p")
