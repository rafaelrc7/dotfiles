vim.cmd "syntax off"

vim.opt_local.foldmethod = "manual"
vim.opt_local.spell = false

local cmp = require "cmp"
if cmp then
	cmp.setup.buffer { enabled = false }
end

local gitsigns = require "gitsigns"
if gitsigns then
	gitsigns.detach()
end

local vim_illuminate = require "illuminate"
if vim_illuminate then
	vim_illuminate.pause_buf()
end

vim.notify("File is larger than 1.5 MB, disabled filetype and other features", vim.log.levels.WARN)
