vim.api.nvim_create_autocmd("BufWritePost", {
	buffer = 0,
	command = [[silent !cargo fmt]],
	group = vim.api.nvim_create_augroup("rustfmt", { clear = true }),
})
