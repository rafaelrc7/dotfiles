require("conform").setup {
	formatters_by_ft = {
		lua = { "stylua" },
		["_"] = { "trim_whitespace", lsp_format = "last" },
	},
	default_format_opts = {
		lsp_format = "fallback",
	},
	format_on_save = function(bufnr)
		-- Disable autoformat on certain filetypes
		local ignore_filetypes = { "mail" }
		if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then return end

		-- Disable with a global or buffer-local variable
		if vim.g.do_not_format or vim.b[bufnr].do_not_format then return end

		return { timeout_ms = 5000 }
	end,
}

vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"

-- Keymaps
vim.keymap.set(
	"",
	"<leader>fmt",
	function() require("conform").format { async = true } end,
	{ desc = "[F]or[m]a[t] code" }
)

-- Autoformat Enable/Disable commands
vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		-- FormatDisable! will disable formatting just for this buffer
		vim.b.do_not_format = true
	else
		vim.g.do_not_format = true
	end
end, {
	desc = "Disable autoformat-on-save",
	bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.do_not_format = false
	vim.g.do_not_format = false
end, {
	desc = "Re-enable autoformat-on-save",
})
