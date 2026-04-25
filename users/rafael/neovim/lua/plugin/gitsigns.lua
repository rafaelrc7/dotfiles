require("gitsigns").setup {
	on_attach = function(bufnr)
		local gitsigns = require "gitsigns"

		local function map(mode, keys, func, desc)
			if desc then desc = "(Git) " .. desc end
			vim.keymap.set(mode, keys, func, { buffer = bufnr, noremap = true, silent = true, desc = desc })
		end

		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				vim.cmd.normal { "]c", bang = true }
			else
				gitsigns.nav_hunk "next"
			end
		end, "Next [c]hange")

		map("n", "[c", function()
			if vim.wo.diff then
				vim.cmd.normal { "[c", bang = true }
			else
				gitsigns.nav_hunk "prev"
			end
		end, "Previous [c]hange")

		map("n", "<leader>gs", gitsigns.stage_hunk, "[s]tage hunk")
		map("n", "<leader>gr", gitsigns.reset_hunk, "[r]eset hunk")
		map("v", "<leader>gs", function() gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" } end, "[s]tage hunk")
		map("v", "<leader>gr", function() gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" } end, "[r]eset hunk")
		map("n", "<leader>gS", gitsigns.stage_buffer, "[s]tage buffer")
		map("n", "<leader>gR", gitsigns.reset_buffer, "[r]eset buffer")
		map("n", "<leader>gp", gitsigns.preview_hunk_inline, "[p]review hunk")
		map("n", "<leader>gb", function() gitsigns.blame_line { full = true } end, "[b]lame hunk")
		map("n", "<leader>gB", gitsigns.toggle_current_line_blame, "toggle line [b]lame")
		map("n", "<leader>gd", gitsigns.diffthis, "[d]iff")
		map("n", "<leader>gD", function() gitsigns.diffthis "~" end, "[d]iff")

		map({ "o", "x" }, "gih", ":<C-U>Gitsigns select_hunk<CR>", "select [h]unk")
	end,
}
