local api = vim.api

local goGroup = api.nvim_create_augroup("gofmt", { clear = true })
api.nvim_create_autocmd("Filetype", {
	pattern = "go",
	command = [[autocmd BufWritePost * silent !gofmt -w %]],
	group = goGroup,
})

local rustGroup = api.nvim_create_augroup("rustfmt", { clear = true })
api.nvim_create_autocmd("Filetype", {
	pattern = "rust",
	command = [[autocmd BufWritePost * silent !cargo fmt]],
	group = rustGroup,
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

local trimGroup = api.nvim_create_augroup("trim", { clear = true })
api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	command = [[:%s/\s\+$//e]],
	group = trimGroup,
})

local neomuttGroup = api.nvim_create_augroup("neomutt", { clear = true })
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*mutt-*",
	callback = function()
		vim.opt.textwidth = 72
		vim.opt.filetype = "mail"
	end,
	group = neomuttGroup,
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
