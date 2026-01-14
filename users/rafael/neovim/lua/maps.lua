-- Map leader key to \
-- Map localleader key to ;
vim.keymap.set("n", ";", "", { noremap = true })
vim.g.mapleader = "\\"
vim.g.maplocalleader = ";"

-- Esc removes highlight
vim.keymap.set("n", "<Esc>", ":nohl<CR>", { silent = true, desc = "Remove highlights" })

-- Toggle spellcheck
vim.keymap.set("", "<leader>s", ":setlocal spell!<CR>", { silent = true, noremap = true, desc = "Toggle [s]pellcheck" })
