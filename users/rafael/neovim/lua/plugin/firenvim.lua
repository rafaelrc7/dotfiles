if vim.g.started_by_firenvim then
	vim.g.firenvim_config = {
		globalSettings = {
			priority = 0,
			cmdline = "neovim",
			messages = "neovim",
		},
		localSettings = {
			[".*"] = {
				priority = 0,
				content = "text",
				cmdline = "neovim",
				messages = "neovim",
				selector = "textarea",
				takeover = "never",
			},
		},
	}
end
