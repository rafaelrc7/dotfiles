local map = vim.api.nvim_set_keymap

-- Map leader key to ,
map("n", ";", "", { noremap = true })
vim.g.mapleader = "\\"
vim.g.maplocalleader = ";"

-- Terminal
map("n", "<leader>tt", ":terminal<CR>", {})
map("n", "<leader>tj", ":bot 10new +terminal | setlocal nobuflisted<CR>", {})
map("n", "<leader>tl", ":botright vnew +terminal | setlocal nobuflisted<CR>", {})
map("t", "<C-e>", "<C-\\><C-n>", {})

-- Ctrl+s saves file
map("", "<C-s>", ":write<CR>", { silent = true })

-- Esc removes highlight
map("n", "<Esc>", ":nohl<CR>", { silent = true })

-- Toggle spellcheck
map("", "<leader>s", ":setlocal spell!<CR>", { silent = true, noremap = true })

-- Window navigation
map("", "<leader>wh", ":wincmd h<CR>", { silent = true, noremap = true })
map("", "<leader>wj", ":wincmd j<CR>", { silent = true, noremap = true })
map("", "<leader>wk", ":wincmd k<CR>", { silent = true, noremap = true })
map("", "<leader>wl", ":wincmd l<CR>", { silent = true, noremap = true })
