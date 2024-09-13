require("gitsigns").setup({
	on_attach = function(bufnr)
		local gitsigns = require("gitsigns")

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end, { desc = "Next [c]hange" })

		map("n", "[c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end, { desc = "Previous [c]hange" })

		map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Git [h]unk [s]tage" })
		map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Git [h]unk [r]eset" })
		map("v", "<leader>hs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Git [h]unk [s]tage" })
		map("v", "<leader>hr", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Git [h]unk [r]eset" })
		map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Git [h]unk [s]tage buffer" })
		map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Git [h]unk [u]ntage" })
		map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Git [h]unk [r]eset buffer" })
		map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Git [h]unk [p]review" })
		map("n", "<leader>hb", function()
			gitsigns.blame_line({ full = true })
		end, { desc = "Git [h]unk [b]lame" })
		map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Git [t]oggle line [b]lame" })
		map("n", "<leader>hd", gitsigns.diffthis, { desc = "Git [h]unk [d]iff" })
		map("n", "<leader>hD", function()
			gitsigns.diffthis("~")
		end, { desc = "Git [h]unk [d]iff" })
		map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "Git [t]oggle [d]eleted" })

		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git select hunk" })
	end,
})
