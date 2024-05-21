local opt = vim.opt
local cmd = vim.cmd

opt.encoding = "utf-8"
opt.mouse = "a"
opt.title = true
opt.cursorline = true
opt.errorbells = false
opt.cmdheight = 2
opt.timeoutlen = 1000
opt.ttimeoutlen = 0
opt.laststatus = 2
opt.number = true
opt.relativenumber = true
opt.smartindent = true
opt.autoindent = true
opt.copyindent = true
opt.expandtab = false
opt.tabstop = 4
opt.softtabstop = 0
opt.shiftwidth = 4
opt.hlsearch = true
opt.incsearch = true
opt.showmatch = true
opt.smartcase = true
opt.clipboard = "unnamedplus"
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.foldmethod = "syntax"
opt.foldlevelstart = 99 -- By default all folds are open
opt.undodir = os.getenv("HOME") .. "/.local/share/nvim/undo"
opt.colorcolumn = { "80", "120" }
opt.completeopt = "menu,menuone,noselect"
opt.termguicolors = true
opt.updatetime = 1000

opt.spelllang = "pt_BR,en_GB"

cmd("filetype plugin on")
