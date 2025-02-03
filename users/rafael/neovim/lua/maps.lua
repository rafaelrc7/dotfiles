local map = function(mode, keys, rhs, opts) vim.keymap.set(mode, keys, rhs, opts) end

-- Map leader key to \
-- Map localleader key to ;
map("n", ";", "", { noremap = true })
vim.g.mapleader = "\\"
vim.g.maplocalleader = ";"

-- Esc removes highlight
map("n", "<Esc>", ":nohl<CR>", { silent = true, desc = "Remove highlights" })

-- Toggle spellcheck
map("", "<leader>s", ":setlocal spell!<CR>", { silent = true, noremap = true, desc = "Toggle [s]pellcheck" })

-- buffers
map("n", "th", ":bprev<CR>", { silent = true, desc = "[T]ab left ([h])" })
map("n", "tl", ":bnext<CR>", { silent = true, desc = "[T]ab right ([l])" })

-- Formatting
local format = require "format"

map(
	"n",
	"<leader>fr",
	function() format.format(0, { async = true }) end,
	{ silent = true, desc = "[F]o[r]mat current buffer" }
)
map("n", "<leader>af", function()
	vim.b.do_not_format = not vim.b.do_not_format
	vim.notify("Autoformat on save was " .. (vim.b.do_not_format and "DISABLED" or "ENABLED"), vim.log.levels.INFO)
end, { silent = true, desc = "Toggle [a]uto [f]ormat for current buffer" })
