vim.opt.background = "dark"

require("gruvbox").setup {
	contrast = "hard",
	overrides = {
		GitSignsAdd = { link = "GruvboxGreenSign" },
		GitSignsChange = { link = "GruvboxOrangeSign" },
		GitSignsDelete = { link = "GruvboxRedSign" },
	},
}

vim.cmd.colorscheme "gruvbox"
