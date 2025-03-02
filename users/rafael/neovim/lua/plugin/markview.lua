local markview = require "markview"

markview.setup {
	preview = {
		enable = true,
		modes = { "n", "i", "nc", "c", "v" },
		hybrid_modes = { "n", "i", "nc", "c", "v" },
		icon_provider = "devicons",
	},
}

local group = vim.api.nvim_create_augroup("MarkviewUserSettings", { clear = true })

vim.api.nvim_create_autocmd("User", {
	pattern = "MarkviewAttach",
	group = group,
	callback = function(ev)
		local buf = ev.buf

		require("markview.extras.checkboxes").setup()
		require("markview.extras.headings").setup()
		require("markview.extras.editor").setup()

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
			"<cmd>Headings increase<cr>",
			{ desc = "[M]arkview [h]eading increase (k)", buffer = buf, silent = true }
		)
		vim.keymap.set(
			{ "n", "v" },
			"<localleader>mhj",
			"<cmd>Headings decrease<cr>",
			{ desc = "[M]arkview [h]eading decrease (j)", buffer = buf, silent = true }
		)

		-- Checkbox binds
		vim.keymap.set(
			{ "n", "v" },
			"<localleader>mct",
			"<cmd>Checkbox toggle<cr>",
			{ desc = "[M]arkview [c]heckbox [t]oggle", buffer = buf, silent = true }
		)

		vim.keymap.set(
			{ "n", "v" },
			"<localleader>mci",
			"<cmd>Checkbox interactive<cr>",
			{ desc = "[M]arkview [c]heckbox [i]nteractive", buffer = buf, silent = true }
		)

		-- Code blocks
		vim.keymap.set(
			{ "n" },
			"<localleader>mbe",
			"<cmd>CodeEdit<cr>",
			{ desc = "[M]arkview code [b]lock [e]dit", buffer = buf, silent = true }
		)
		vim.keymap.set(
			{ "n" },
			"<localleader>mbc",
			"<cmd>CodeCreate<cr>",
			{ desc = "[M]arkview code [b]lock [c]reate", buffer = buf, silent = true }
		)
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "MarkviewDetach",
	group = group,
	callback = function(ev)
		local buf = ev.buf

		vim.keymap.del({ "n" }, "<localleader>ms", { buffer = buf })

		vim.keymap.del({ "n", "v" }, "<localleader>mhk", { buffer = buf })
		vim.keymap.del({ "n", "v" }, "<localleader>mhj", { buffer = buf })

		vim.keymap.del({ "n", "v" }, "<localleader>mct", { buffer = buf })
		vim.keymap.del({ "n", "v" }, "<localleader>mci", { buffer = buf })

		vim.keymap.del({ "n" }, "<localleader>mbe", { buffer = buf })
		vim.keymap.del({ "n" }, "<localleader>mbc", { buffer = buf })
	end,
})
