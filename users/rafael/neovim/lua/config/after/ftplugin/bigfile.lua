vim.cmd "sytax off"

vim.opt_local.foldmethod = "manual"
vim.opt_local.spell = false
vim.b.completion = false
vim.b.indent_guide = false

do
	local ok, cmp = pcall(require, "cmp")
	if ok then cmp.setup.buffer { enabled = false } end
end

do
	local ok, gitsigns = pcall(require, "gitsigns")
	if ok then gitsigns.detach() end
end

do
	local ok, vim_illuminate = pcall(require, "illuminate")
	if ok then vim_illuminate.pause_buf() end
end

vim.notify("File is larger than 1.5 MB, disabled filetype and other features", vim.log.levels.WARN)
