require("toggleterm").setup {
	open_mapping = [[<c-\>]],
	direction = "horizontal",
}

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.api.nvim_clear_autocmds {
	event = "TermOpen",
	pattern = "term://*",
}

vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "term://*",
	callback = function()
		vim.keymap.set("t", "<ESC>", [[<C-\><C-N>]], { buffer = 0, silent = true, desc = "(ToggleTerm) Normal mode" })
		vim.keymap.set(
			"t",
			"<C-W>",
			[[<C-\><C-N><C-W>]],
			{ buffer = 0, silent = true, desc = "(ToggleTerm) Navigate to" }
		)
	end,
	group = vim.api.nvim_create_augroup("toggleterm_keybinds", { clear = true }),
	desc = "Add keybinds to terminal buffers for easier navigation.",
})
