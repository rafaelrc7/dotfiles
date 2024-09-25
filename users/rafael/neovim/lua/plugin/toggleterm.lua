require("toggleterm").setup {
	open_mapping = [[<c-\>]],
	direction = "horizontal",
}

function _G.set_terminal_keymaps()
	local map = function(mode, keys, func, desc)
		if desc then desc = "ToggleTerm " .. desc end
		vim.keymap.set(mode, keys, func, { buffer = 0, desc = desc, silent = true })
	end

	map("t", "<esc>", [[<C-\><C-n>]], "Normal mode")
	map("t", "<C-w>", [[<C-\><C-n><C-w>]], "Navigate to")
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd "autocmd! TermOpen term://* lua set_terminal_keymaps()"
