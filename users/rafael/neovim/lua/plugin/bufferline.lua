require("bufferline").setup {
	highlights = require("catppuccin.special.bufferline").get_theme(),
	options = {
		diagnostics = "nvim_lsp",
		color_icons = true,
		separator_style = "slant",
		hover = {
			enabled = true,
			delay = 200,
			reveal = { "close" },
		},
	},
}
