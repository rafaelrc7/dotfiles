local snacks = require "snacks"

snacks.setup {
	bigfile = {},
	bufdelete = {},
	gh = {},
	git = {},
	gitbrowse = {},
	image = {},
	indent = {},
	input = {},
	notifier = {},
	notify = {},
	picker = {
		sources = {
			gh_issues = {},
			gh_pr = {},
		},
		actions = require("trouble.sources.snacks").actions,
		win = {
			input = {
				["<c-t>"] = {
					"trouble_open",
					mode = { "n", "i" },
				},
			},
		},
	},
	quickfile = {},
	scratch = {},
	terminal = {},
	win = {},
}

-- Scratch
vim.keymap.set("n", "<leader>.", function() Snacks.scratch() end, { desc = "Toggle Scratch Buffer" })
vim.keymap.set("n", "<leader>S", function() Snacks.scratch.select() end, { desc = "Toggle Scratch Buffer" })

-- Rename
vim.api.nvim_create_autocmd("User", {
	pattern = "OilActionsPost",
	callback = function(event)
		if event.data.actions[1].type == "move" then
			Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
		end
	end,
})

-- Terminal
vim.keymap.set("n", "<leader>tt", function() Snacks.terminal.toggle() end, { desc = "[T]erminal [t]oggle" })
vim.keymap.set("n", "<leader>tn", function() Snacks.terminal.open() end, { desc = "[T]erminal new" })

-- Picker
-- -- Pickers
vim.keymap.set("n", "<leader><space>", function() Snacks.picker.smart() end, { desc = "Smart find files" })
vim.keymap.set("n", "<leader>,", function() Snacks.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep" })
vim.keymap.set("n", "<leader>*", function() Snacks.picker.grep_word() end, { desc = "Grep Word under cursor" })
vim.keymap.set("n", "<leader>:", function() Snacks.picker.command_history() end, { desc = "Command History" })
vim.keymap.set("n", "<leader>n", function() Snacks.picker.notifications() end, { desc = "Notification History" })
vim.keymap.set("n", "<leader>e", function() Snacks.explorer() end, { desc = "File Explorer" })

-- -- Find
vim.keymap.set("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>fB", function() Snacks.picker.grep_buffers() end, { desc = "Find in open buffers" })
vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fp", function() Snacks.picker.projects() end, { desc = "Find Projects" })
vim.keymap.set("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Find Recent" })
vim.keymap.set("n", "<leader>fl", function() Snacks.picker.lines() end, { desc = "Find Line in buffer" })

-- -- Search
vim.keymap.set("n", '<leader>s"', function() Snacks.picker.registers() end, { desc = "Search Registers" })
vim.keymap.set("n", "<leader>s/", function() Snacks.picker.search_history() end, { desc = "Search search history" })
vim.keymap.set("n", "<leader>sc", function() Snacks.picker.command_history() end, { desc = "Search command history" })
vim.keymap.set("n", "<leader>sC", function() Snacks.picker.commands() end, { desc = "Search commands" })
vim.keymap.set("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Search Help" })
vim.keymap.set("n", "<leader>si", function() Snacks.picker.icons() end, { desc = "Search Icons" })
vim.keymap.set("n", "<leader>sq", function() Snacks.picker.qflist() end, { desc = "Search quickfix list" })
vim.keymap.set("n", "<leader>sl", function() Snacks.picker.loclist() end, { desc = "Search local list" })
vim.keymap.set("n", "<leader>sM", function() Snacks.picker.man() end, { desc = "Search man pages" })
vim.keymap.set("n", "<leader>sp", function() Snacks.picker.spelling() end, { desc = "Search spelling suggestions" })
vim.keymap.set("n", "<leader>su", function() Snacks.picker.undo() end, { desc = "Search undo history" })

-- -- LSP
vim.keymap.set("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, { desc = "Search Document Symbols" })
vim.keymap.set(
	"n",
	"<leader>sS",
	function() Snacks.picker.lsp_workspace_symbols() end,
	{ desc = "Search Workspace Symbols" }
)

-- -- Git
vim.keymap.set("n", "<leader>fgf", function() Snacks.picker.git_files() end, { desc = "Find Git Files" })
vim.keymap.set("n", "<leader>fgl", function() Snacks.picker.git_log() end, { desc = "Search Git Log" })
vim.keymap.set("n", "<leader>fgs", function() Snacks.picker.git_status() end, { desc = "Search Git Status" })
vim.keymap.set("n", "<leader>fgS", function() Snacks.picker.git_stash() end, { desc = "Search Git Stash" })
vim.keymap.set("n", "<leader>fgd", function() Snacks.picker.git_diff() end, { desc = "Search Git Diff" })

-- -- Github
vim.keymap.set(
	"n",
	"<leader>fgi",
	function() Snacks.picker.gh_issue() end,
	{ desc = "Picker [f]ind [g]ithub [i]ssue (open)" }
)
vim.keymap.set(
	"n",
	"<leader>fgI",
	function() Snacks.picker.gh_issue { state = "all" } end,
	{ desc = "Picker [f]ind [g]ithub [i]ssue (all)" }
)

vim.keymap.set(
	"n",
	"<leader>fgp",
	function() Snacks.picker.gh_pr() end,
	{ desc = "Picker [f]ind [g]ithub [p]r (open)" }
)
vim.keymap.set(
	"n",
	"<leader>fgP",
	function() Snacks.picker.gh_pr { state = "all" } end,
	{ desc = "Picker [f]ind [g]ithub [p]r (all)" }
)
