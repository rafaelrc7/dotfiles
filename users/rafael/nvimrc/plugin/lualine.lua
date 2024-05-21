require("lualine").setup({
	options = {
		theme = "base16",
		section_separators = "",
		component_separators = "",
	},
	sections = {
		lualine_c = {
			"filename",
			"lsp_progress",
		},
	},
})
