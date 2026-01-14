local ht = require "haskell-tools"

-- Hoogle search for the type signature of the definition under the cursor
vim.keymap.set(
	"n",
	"<localleader>hs",
	ht.hoogle.hoogle_signature,
	{ buffer = true, noremap = true, silent = true, desc = "(Haskell) [H]oogle [S]ignature" }
)

-- Evaluate all code snippets
vim.keymap.set(
	"n",
	"<localleader>ea",
	ht.lsp.buf_eval_all,
	{ buffer = true, noremap = true, silent = true, desc = "(Haskell) Buffer [e]val [a]ll" }
)

-- Toggle a GHCi repl for the current package
vim.keymap.set(
	"n",
	"<localleader>rr",
	ht.repl.toggle,
	{ buffer = true, noremap = true, silent = true, desc = "(Haskell) [R]epl toggle" }
)

-- Toggle a GHCi repl for the current buffer
vim.keymap.set(
	"n",
	"<localleader>rf",
	function() ht.repl.toggle(vim.api.nvim_buf_get_name(0)) end,
	{ buffer = true, noremap = true, silent = true, desc = "(Haskell) [R]epl toggle in [f]ile" }
)
vim.keymap.set(
	"n",
	"<localleader>rq",
	ht.repl.quit,
	{ buffer = true, noremap = true, silent = true, desc = "(Haskell) [R]epl [q]uit" }
)

vim.opt_local.tabstop = 8
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true
