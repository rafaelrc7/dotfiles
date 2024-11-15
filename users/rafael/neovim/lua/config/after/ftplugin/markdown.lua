vim.api.nvim_set_keymap(
	"n",
	"<localleader>mp",
	":MarkdownPreview<CR>",
	{ silent = true, noremap = true, desc = "[M]arkdown [p]review" }
)

vim.opt_local.spell = true
