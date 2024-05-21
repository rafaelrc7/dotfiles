local map = vim.keymap.set

require("telescope").setup({
	defaults = {
		prompt_prefix = " >",
		color_devicons = true,

		file_previewer = require("telescope.previewers").vim_buffer_cat.new,
		grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
		qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
})

require("telescope").load_extension("fzf")

-- Telescope
local builtin = require("telescope.builtin")
map("n", "<leader>fg", builtin.live_grep, {})
map({ "n", "v" }, "<leader>f*", builtin.grep_string, {})
map("n", "<leader>ff", builtin.find_files, {})
map("n", "<leader>fb", builtin.buffers, {})
map("n", "<leader>fh", builtin.help_tags, {})
map("n", "<leader>fc", builtin.commands, {})
map({ "n", "v" }, "<leader>fq", builtin.quickfix, {})
map({ "n", "v" }, "<leader>fs", builtin.spell_suggest, {})
map("n", "<leader>fgs", builtin.git_status, {})
map("n", "<leader>fgc", builtin.git_commits, {})
