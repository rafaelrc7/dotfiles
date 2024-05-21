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

-- Toggles file tree
map("", "<C-n>", ":NvimTreeToggle<CR>", { silent = true })

-- Esc removes highlight
map("n", "<Esc>", ":nohl<CR>", { silent = true })

-- Shift+M starts Markdown Preview
map("n", "<S-m>", ":MarkdownPreview<CR>", { silent = true, noremap = true })

-- Toggle spellcheck
map("", "<leader>s", ":setlocal spell!<CR>", { silent = true, noremap = true })

-- Window navigation
map("", "<leader>h", ":wincmd h<CR>", { silent = true, noremap = true })
map("", "<leader>j", ":wincmd j<CR>", { silent = true, noremap = true })
map("", "<leader>k", ":wincmd k<CR>", { silent = true, noremap = true })
map("", "<leader>l", ":wincmd l<CR>", { silent = true, noremap = true })

-- Fugitive
map("n", "<leader>gs", ":G<CR>", {}) -- git status
map("n", "<leader>gdf", ":diffget //2<CR>", {})
map("n", "<leader>gdj", ":diffget //3<CR>", {})
