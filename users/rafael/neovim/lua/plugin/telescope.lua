local map = vim.keymap.set

local telescope = require("telescope")

local builtin = require("telescope.builtin")
local previewers = require("telescope.previewers")

telescope.setup({
	defaults = {
		prompt_prefix = " >",
		color_devicons = true,

		file_previewer = previewers.vim_buffer_cat.new,
		grep_previewer = previewers.vim_buffer_vimgrep.new,
		qflist_previewer = previewers.vim_buffer_qflist.new,
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

telescope.load_extension("fzf")
telescope.load_extension("ui-select")

-- Telescope
map("n", "<leader>fw", builtin.live_grep, { desc = "Telescope [f]ind [w]ord (grep)" })
map({ "n", "v" }, "<leader>f*", builtin.grep_string, { desc = "Telescope [f]ind word under cursor" })
map("n", "<leader>ff", builtin.find_files, { desc = "Telescope [f]ind [f]ile" })
map("n", "<leader>fb", builtin.buffers, { desc = "Telescope [f]ind [b]uffer" })
map("n", "<leader>fh", builtin.help_tags, { desc = "Telescope [f]ind [h]elp tag" })
map("n", "<leader>fc", builtin.commands, { desc = "Telescope [f]ind [c]ommand" })
map({ "n", "v" }, "<leader>fq", builtin.quickfix, { desc = "Telescope [f]ind [q]uickfix item" })
map({ "n", "v" }, "<leader>fs", builtin.spell_suggest, { desc = "Telescope [f]ind [s]pell suggestion" })
map("n", "<leader>fgs", builtin.git_status, { desc = "Telescope [f]ind in [g]it [s]tatus" })
map("n", "<leader>fgc", builtin.git_commits, { desc = "Telescope [f]ind [g]it [c]ommit" })
