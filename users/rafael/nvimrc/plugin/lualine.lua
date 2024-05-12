require("lualine").setup({
	options = {
		theme = "dracula-nvim",
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
