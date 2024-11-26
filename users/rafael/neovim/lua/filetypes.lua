vim.filetype.add {
	pattern = {
		-- bigfile
		[".*"] = {
			function(path, buf)
				-- bigger than 1.5MB
				return vim.bo[buf]
					and vim.bo[buf].filetype ~= "bigfile"
					and path
					and vim.fn.getfsize(path) > 1.5 * 1024 * 1024
					and "bigfile"
					or nil
			end,
		},

		-- mutt mail
		[".*mutt%-.*"] = "mail",
	},

	filename = {
		["docker-compose.yml"] = "yaml.docker-compose",
	},
}
