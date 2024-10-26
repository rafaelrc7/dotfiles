require("trouble.config").setup {
	focus = false,
	open_no_results = true,

	modes = {
		lsp = {
			win = { position = "right" },
		},

		lsp_document_symbols = {
			win = { position = "right" },
		},
	},
}

local map = vim.keymap.set
local trouble = require "trouble"

map("n", "<leader>xx", function() trouble.toggle "diagnostics" end, { desc = "Trouble toggle workspace diagnostics" })

map(
	"n",
	"<leader>xd",
	function()
		trouble.toggle {
			mode = "diagnostics",
			filter = { buf = 0 },
			pinned = true,
		}
	end,
	{ desc = "Trouble toggle [d]ocument diagnostics" }
)

map(
	"n",
	"<leader>xs",
	function() trouble.toggle "lsp_document_symbols" end,
	{ desc = "Trouble toggle document [s]ymbols" }
)

map("n", "<leader>xl", function() trouble.toggle "lsp" end, { desc = "Trouble toggle [l]sp info" })

map("n", "<leader>xL", function() trouble.toggle "loclist" end, { desc = "Trouble toggle [l]oclist" })

map("n", "<leader>xQ", function() trouble.toggle "quickfix" end, { desc = "Trouble toggle [q]flist" })
