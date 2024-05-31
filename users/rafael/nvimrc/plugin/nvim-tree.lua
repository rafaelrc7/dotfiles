local api = vim.api

-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close
api.nvim_create_autocmd("BufEnter", {
	nested = true,
	callback = function()
		if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
			vim.cmd("quit")
		end
	end,
	group = api.nvim_create_augroup("nvim_tree_quit", { clear = true }),
})

require("nvim-tree").setup({
	disable_netrw = true,
	hijack_netrw = true,
	open_on_tab = true,
	filters = {
		custom = { "^.git$", "^node_modules$", "^.cache$" },
	},
	actions = {
		open_file = {
			quit_on_open = true,
		},
	},
	renderer = {
		highlight_opened_files = "all",
	},
})

-- Toggles file tree
vim.api.nvim_set_keymap("", "<C-n>", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle nvim-tree" })
