local api = vim.api

api.nvim_create_autocmd("FileType", {
	pattern = "java",
	callback = function(_)
		require("jdtls").start_or_attach({
			cmd = { vim.fn.executable("jdtls.sh") == 1 and "jdtls.sh" or "jdtls" },
			root_dir = vim.fs.dirname(
				vim.fs.find({ "gradlew", ".git", "mvnw", "flake.nix", "Makefile" }, { upward = true })[1]
			),
		})
	end,
	group = api.nvim_create_augroup("jdtls_autostart", { clear = true }),
})
