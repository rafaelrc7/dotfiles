local api = vim.api

api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function(ev)
		local saved_view = vim.fn.winsaveview()

		local lines = vim.api.nvim_buf_get_lines(ev.buf, 0, -1, false)
		local gofmt = vim.system({ "gofmt" }, { text = true, stdin = lines }):wait()

		if gofmt.code == 0 then
			lines = {}
			for line in gofmt.stdout:gmatch("(.-)\n") do
				table.insert(lines, line)
			end

			vim.api.nvim_buf_set_lines(ev.buf, 0, -1, false, lines)
		elseif gofmt.stderr ~= nil then
			lines = {}
			local err = gofmt.stderr:gsub("<standard input>", vim.fn.expand("%"))
			for line in err:gmatch("(.-)\n") do
				table.insert(lines, line)
			end

			vim.fn.setqflist({}, " ", { bufnr = ev.buf, lines = lines })
		end

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
