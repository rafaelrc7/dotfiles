require("gitsigns").setup {
	on_attach = function(bufnr)
		local gitsigns = require "gitsigns"

		local function map(mode, keys, func, desc)
			if desc then desc = "Git " .. desc end
			vim.keymap.set(mode, keys, func, { noremap = true, buffer = bufnr, desc = desc, silent = true })
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

		map("n", "<leader>hs", gitsigns.stage_hunk, "[h]unk [s]tage")
		map("n", "<leader>hr", gitsigns.reset_hunk, "[h]unk [r]eset")
		map(
			"v",
			"<leader>hs",
			function() gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" } end,
			"[h]unk [s]tage"
		)
		map(
			"v",
			"<leader>hr",
			function() gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" } end,
			"[h]unk [r]eset"
		)
		map("n", "<leader>hS", gitsigns.stage_buffer, "[h]unk [s]tage buffer")
		map("n", "<leader>hu", gitsigns.undo_stage_hunk, "[h]unk [u]nstage")
		map("n", "<leader>hR", gitsigns.reset_buffer, "[h]unk [r]eset buffer")
		map("n", "<leader>hp", gitsigns.preview_hunk, "[h]unk [p]review")
		map("n", "<leader>hb", function() gitsigns.blame_line { full = true } end, "[h]unk [b]lame")
		map("n", "<leader>tb", gitsigns.toggle_current_line_blame, "[t]oggle line [b]lame")
		map("n", "<leader>hd", gitsigns.diffthis, "[h]unk [d]iff")
		map("n", "<leader>hD", function() gitsigns.diffthis "~" end, "[h]unk [d]iff")
		map("n", "<leader>td", gitsigns.toggle_deleted, "[t]oggle [d]eleted")

		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "select [h]unk")
	end,
}
