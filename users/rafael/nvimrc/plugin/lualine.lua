require("lualine").setup({
	options = {
		theme = "gruvbox_dark",
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
