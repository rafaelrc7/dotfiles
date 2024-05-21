require("lualine").setup({
	options = {
		theme = "auto",
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
