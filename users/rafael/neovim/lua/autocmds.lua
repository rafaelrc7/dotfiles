vim.api.nvim_create_autocmd("VimResized", {
	command = "wincmd =",
	group = vim.api.nvim_create_augroup("autoresize_windows_on_terminal_resize", { clear = true }),
})

local function updateColorColumn()
	local textwidth = vim.opt_local.textwidth:get()
	if not textwidth or textwidth == 0 then
		vim.opt_local.colorcolumn = { "80", "120" }
	else
		vim.opt_local.colorcolumn = tostring(textwidth)
	end
end

local colorColumnGroup = vim.api.nvim_create_augroup("colorcolumn", { clear = true })
vim.api.nvim_create_autocmd("OptionSet", {
	pattern = "textwidth",
	callback = updateColorColumn,
	group = colorColumnGroup,
})
vim.api.nvim_create_autocmd("BufEnter", {
	callback = updateColorColumn,
	group = colorColumnGroup,
})

local saveFileView = vim.api.nvim_create_augroup("saveFileView", { clear = true })
vim.api.nvim_create_autocmd({ "BufWinLeave", "BufWritePost", "WinLeave" }, {
	desc = "Save file view",
	group = saveFileView,
	callback = function(ev)
		if not vim.b[ev.buf].view_loaded then return end

		vim.cmd.mkview { mods = { emsg_silent = true } }
	end,
})
vim.api.nvim_create_autocmd("BufWinEnter", {
	desc = "Load file view",
	group = saveFileView,
	callback = function(ev)
		if vim.b[ev.buf].view_loaded then return end

		local ignoreFt = {
			"bigfile",
			"dirbuf",
			"dirvish",
			"fugitive",
			"gitcommit",
			"gitrebase",
			"hgcommit",
			"NvimTree",
			"oil",
			"svg",
		}

		local ft = vim.opt_local.filetype:get()
		local bt = vim.opt_local.buftype:get()

		if bt ~= "" or not ft or ft == "" or vim.tbl_contains(ignoreFt, ft) then return end

		vim.cmd.loadview { mods = { emsg_silent = true } }
		vim.b[ev.buf].view_loaded = true
	end,
})
