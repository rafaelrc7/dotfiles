vim.keymap.set(
	"n",
	"<localleader>mp",
	":MarkdownPreview<CR>",
	{ buffer = true, noremap = true, silent = true, desc = "[M]arkdown [p]review" }
)

vim.opt_local.spell = true
