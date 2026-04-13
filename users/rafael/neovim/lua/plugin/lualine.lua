local navic = require "nvim-navic"

local navic_module = {
	"navic",
	draw_empty = true,
	color_correction = "static",
	cond = function()
		-- Also draw empty bar in git blame windows to keep line alignment
		return navic.is_available() or vim.bo.filetype == "fugitiveblame"
	end,
}

require("lualine").setup {
	options = {
		icons_enabled = true,
		theme = "auto",
	},
	sections = {
		lualine_c = {
			"filename",
		},
	},
	winbar = {
		lualine_c = {
			navic_module,
		},
	},
	inactive_winbar = {
		lualine_c = {
			navic_module,
		},
	},
}
