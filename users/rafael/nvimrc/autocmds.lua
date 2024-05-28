local api = vim.api

api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function(_)
		local saved_view = vim.fn.winsaveview()
		pcall(function()
			vim.cmd([[
			silent %!gofmt
			if v:shell_error > 0
				cexpr getline(1, '$')->map({ idx, val -> val->substitute('<standard input>', expand('%'), '') })
				silent undo
			endif
		]])
		end)
		vim.fn.winrestview(saved_view)
	end,
	group = api.nvim_create_augroup("gofmt", { clear = true }),
})

api.nvim_create_autocmd("FileType", {
	pattern = "rust",
	command = [[autocmd BufWritePost * silent !cargo fmt]],
	group = api.nvim_create_augroup("rustfmt", { clear = true }),
})

api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	buffer = bufnr,
	callback = vim.lsp.buf.format,
	group = api.nvim_create_augroup("lspformat", { clear = true }),
})

local indentGroup = api.nvim_create_augroup("indent", { clear = true })
api.nvim_create_autocmd("FileType", {
	pattern = { "haskell", "cabal" },
	command = [[:setlocal shiftwidth=2 softtabstop=2 tabstop=8 expandtab]],
	group = indentGroup,
})
api.nvim_create_autocmd("FileType", {
	pattern = "nix",
	command = [[:setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab]],
	group = indentGroup,
})
api.nvim_create_autocmd("FileType", {
	pattern = "elixir",
	command = [[:setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab]],
	group = indentGroup,
})
api.nvim_create_autocmd("FileType", {
	pattern = "asm",
	command = [[:setlocal shiftwidth=8 tabstop=8]],
	group = indentGroup,
})

api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(_)
		local saved_view = vim.fn.winsaveview()
		pcall(function()
			vim.cmd([[%s/\s\+$//e]])
		end)
		vim.fn.winrestview(saved_view)
	end,
	group = api.nvim_create_augroup("trim_whitespace_on_save", { clear = true }),
})

api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*mutt-*",
	callback = function()
		vim.opt.textwidth = 72
		vim.opt.filetype = "mail"
	end,
	group = api.nvim_create_augroup("neomutt", { clear = true }),
})

local function updateColorColumn()
	local textwidth = vim.opt.textwidth:get()
	if not textwidth or textwidth == 0 then
		vim.opt.colorcolumn = { "80", "120" }
	else
		vim.opt.colorcolumn = tostring(textwidth)
	end
end

local colorColumnGroup = api.nvim_create_augroup("colorcolumn", { clear = true })
api.nvim_create_autocmd("OptionSet", {
	pattern = "textwidth",
	callback = updateColorColumn,
	group = colorColumnGroup,
})
api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = updateColorColumn,
	group = colorColumnGroup,
})
