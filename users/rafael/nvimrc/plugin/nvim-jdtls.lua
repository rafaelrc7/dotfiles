require("utils").nvim_create_augroups({
	jdtls_auto = {
		{
			"FileType",
			"java",
			[[lua
				local config = {
					cmd = { vim.fn.executable("jdtls.sh") == 1 and "jdtls.sh" or "jdtls" },
					root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw', 'flake.nix', 'Makefile'}, { upward = true })[1]),
				}

				require('jdtls').start_or_attach(config)
			]],
		},
	},
})
