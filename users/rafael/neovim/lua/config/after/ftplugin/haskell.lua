local ht = require "haskell-tools"
local bufnr = vim.api.nvim_get_current_buf()

local function map(mode, keys, func, desc)
	if desc then desc = "Haskell " .. desc end
	vim.keymap.set(mode, keys, func, { noremap = true, buffer = bufnr, desc = desc, silent = true })
end

-- Hoogle search for the type signature of the definition under the cursor
map("n", "<localleader>hs", ht.hoogle.hoogle_signature, "[H]oogle [S]ignature")
-- Evaluate all code snippets
map("n", "<localleader>ea", ht.lsp.buf_eval_all, "Buffer [e]val [a]ll")
-- Toggle a GHCi repl for the current package
map("n", "<localleader>rr", ht.repl.toggle, "[R]epl toggle")
-- Toggle a GHCi repl for the current buffer
map("n", "<localleader>rf", function() ht.repl.toggle(vim.api.nvim_buf_get_name(0)) end, "[R]epl toggle in [f]ile")
map("n", "<localleader>rq", ht.repl.quit, "[R]epl [q]uit")

vim.opt_local.tabstop = 8
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true
