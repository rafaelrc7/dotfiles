local api = vim.api

api.nvim_create_autocmd("BufWritePre", {
	callback = function(_)
		local saved_view = vim.fn.winsaveview()
		pcall(function() vim.cmd [[%s/\s\+$//e]] end)
		vim.fn.winrestview(saved_view)
	end,
	group = api.nvim_create_augroup("trim_whitespace_on_save", { clear = true }),
})

local function updateColorColumn()
	local textwidth = vim.opt_local.textwidth:get()
	if not textwidth or textwidth == 0 then
		vim.opt_local.colorcolumn = { "80", "120" }
	else
		vim.opt_local.colorcolumn = tostring(textwidth)
	end
end

local colorColumnGroup = api.nvim_create_augroup("colorcolumn", { clear = true })
api.nvim_create_autocmd("OptionSet", {
	pattern = "textwidth",
	callback = updateColorColumn,
	group = colorColumnGroup,
})
api.nvim_create_autocmd("BufEnter", {
	callback = updateColorColumn,
	group = colorColumnGroup,
})
