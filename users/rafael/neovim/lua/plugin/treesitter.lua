vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("treesitter_auto_enable", { clear = true }),
	callback = function(ev)
		-- Don't enable on big files --
		if vim.bo.filetype == "bigfile" then return end

		local ok, _ = pcall(vim.treesitter.start, ev.buf)
		if not ok then return end
		vim.opt_local.foldmethod = "expr"
		vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.opt_local.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})
