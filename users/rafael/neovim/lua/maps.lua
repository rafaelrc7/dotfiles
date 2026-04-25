-- Map leader key to \
-- Map localleader key to ;
vim.keymap.set("n", ";", "", { noremap = true })
vim.g.mapleader = "\\"
vim.g.maplocalleader = ";"

-- Toggle spellcheck
vim.keymap.set("", "<leader>s", ":setlocal spell!<CR>", { silent = true, noremap = true, desc = "Toggle [s]pellcheck" })
