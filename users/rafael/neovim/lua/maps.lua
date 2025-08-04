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
