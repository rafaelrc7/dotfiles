vim.filetype.add {
	pattern = {
		-- mutt mail
		[".*mutt%-.*"] = "mail",

		-- Angular HTML templates
		[".*%.html"] = function(_, bufnr) return vim.fs.root(bufnr, "angular.json") ~= nil and "htmlangular" or nil end,
	},

	filename = {
		["docker-compose.yml"] = "yaml.docker-compose",
	},
}
