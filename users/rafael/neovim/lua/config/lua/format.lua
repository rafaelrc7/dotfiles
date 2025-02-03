local M = {}

M.format = function(bufnr, opts)
	if not vim.bo.modifiable then return end

	if vim.b.formatter then
		local bufname = vim.api.nvim_buf_get_name(bufnr)
		local ret = vim.b.formatter(bufname, bufnr)
		if ret then return end
	end

	local clients = vim.lsp.get_clients { bufner = bufnr, method = "textDocument/formatting" }
	if #clients > 0 then
		opts.bufnr = bufnr
		vim.lsp.buf.format(opts)
		vim.diagnostic.show(nil, bufnr)
		return
	end
end

return M
