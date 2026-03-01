vim.filetype.add {
	pattern = {
		-- bigfile
		[".*"] = {
			function(path, bufnr)
				-- bigger than 1.5MB
				return vim.bo[bufnr]
						and vim.bo[bufnr].filetype ~= "bigfile"
						and path
						and vim.fn.getfsize(path) > 1.5 * 1024 * 1024
						and "bigfile"
					or nil
			end,
		},

		-- mutt mail
		[".*mutt%-.*"] = "mail",

		-- Angular HTML templates
		[".*%.html"] = function(_, bufnr) return vim.fs.root(bufnr, "angular.json") ~= nil and "htmlangular" or nil end,
	},

	filename = {
		["docker-compose.yml"] = "yaml.docker-compose",
	},
}
