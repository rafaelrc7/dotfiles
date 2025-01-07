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

local noice = require "noice"

local macro_recording_module = {
	noice.api.status.mode.get,
	cond = noice.api.status.mode.has,
	color = { gui = "bold", fg = "orange" },
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
		lualine_x = {
			macro_recording_module,
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
