vim.g.haskell_tools = {
	hls = {
		settings = {
			haskell = {
				formattingProvider = "stylish-haskell",
				plugin = {
					rename = {
						config = {
							crossModule = true,
						},
					},
				},
			},
		},
	},
}
