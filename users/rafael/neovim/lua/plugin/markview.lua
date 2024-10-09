local markview = require "markview"

local default_on_enable = markview.configuration.callbacks.on_enable
local default_on_disable = markview.configuration.callbacks.on_disable

markview.setup {
	callbacks = {
		on_enable = function(buf, win)
			pcall(default_on_enable, buf, win)

			-- General binds
			vim.keymap.set(
				{ "n" },
				"<localleader>mv",
				"<cmd>Markview toggle<cr>",
				{ desc = "[M]ark[v]iew toggle", buffer = buf, silent = true }
			)
			vim.keymap.set(
				{ "n" },
				"<localleader>ms",
				"<cmd>Markview splitToggle<cr>",
				{ desc = "[M]arkview toggle [s]plit view", buffer = buf, silent = true }
			)

			-- Heading binds
			vim.keymap.set(
				{ "n", "v" },
				"<localleader>mhk",
				require("markview.extras.headings").increase,
				{ desc = "[M]arkview [h]eading increase (k)", buffer = buf, silent = true }
			)
			vim.keymap.set(
				{ "n", "v" },
				"<localleader>mhj",
				require("markview.extras.headings").decrease,
				{ desc = "[M]arkview [h]eading decrease (j)", buffer = buf, silent = true }
			)

			-- Checkbox binds
			vim.keymap.set(
				{ "n", "v" },
				"<localleader>mtt",
				require("markview.extras.checkboxes").toggle,
				{ desc = "[M]arkview [t]ask [t]oggle", buffer = buf, silent = true }
			)
			vim.keymap.set(
				{ "n", "v" },
				"<localleader>mtl",
				function() require("markview.extras.checkboxes").forward(true) end,
				{ desc = "[M]arkview [t]ask next (l)", buffer = buf, silent = true }
			)
			vim.keymap.set(
				{ "n", "v" },
				"<localleader>mth",
				function() require("markview.extras.checkboxes").backward(true) end,
				{ desc = "[M]arkview [t]ask previous (h)", buffer = buf, silent = true }
			)
			vim.keymap.set(
				{ "n", "v" },
				"<localleader>mtj",
				function() require("markview.extras.checkboxes").next(true) end,
				{ desc = "[M]arkview [t]ask next set (j)", buffer = buf, silent = true }
			)
			vim.keymap.set(
				{ "n", "v" },
				"<localleader>mtk",
				function() require("markview.extras.checkboxes").previous(true) end,
				{ desc = "[M]arkview [t]ask previous set (k)", buffer = buf, silent = true }
			)

			-- Code blocks
			vim.keymap.set(
				{ "n" },
				"<localleader>mce",
				require("markview.extras.editor").open,
				{ desc = "[M]arkview [c]ode [e]dit", buffer = buf, silent = true }
			)
			vim.keymap.set(
				{ "n" },
				"<localleader>mcc",
				require("markview.extras.editor").create,
				{ desc = "[M]arkview [c]ode [c]reate", buffer = buf, silent = true }
			)
		end,

		on_disable = function(buf, win)
			pcall(default_on_disable, buf, win)

			vim.keymap.del({ "n" }, "<localleader>ms", { buffer = buf })

			vim.keymap.del({ "n", "v" }, "<localleader>mhk", { buffer = buf })
			vim.keymap.del({ "n", "v" }, "<localleader>mhj", { buffer = buf })

			vim.keymap.del({ "n", "v" }, "<localleader>mtt", { buffer = buf })
			vim.keymap.del({ "n", "v" }, "<localleader>mtl", { buffer = buf })
			vim.keymap.del({ "n", "v" }, "<localleader>mth", { buffer = buf })
			vim.keymap.del({ "n", "v" }, "<localleader>mtj", { buffer = buf })
			vim.keymap.del({ "n", "v" }, "<localleader>mtk", { buffer = buf })

			vim.keymap.del({ "n" }, "<localleader>mce", { buffer = buf })
			vim.keymap.del({ "n" }, "<localleader>mcc", { buffer = buf })
		end,
	},
	modes = { "n", "i", "nc", "c", "v" },
	hybrid_modes = { "n", "i", "nc", "c", "v" },
}
