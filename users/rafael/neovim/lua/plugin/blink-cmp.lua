require("blink.cmp").setup {
	keymap = { preset = "default" },

	appearance = {
		nerd_font_variant = "mono",
	},

	completion = { documentation = { auto_show = true } },

	sources = {
		default = { "lazydev", "lsp", "latex", "path", "snippets", "buffer", "emoji" },
		per_filetype = {
			text = { inherit_defaults = true, "thesaurus" },
			tex = { inherit_defaults = true, "thesaurus" },
			markdown = { inherit_defaults = true, "thesaurus", "git" },
			gitcommit = { inherit_defaults = true, "git" },
			octo = { inherit_defaults = true, "git" },
		},
		providers = {
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				score_offset = 100,
			},
			git = {
				name = "Git",
				module = "blink-cmp-git",
			},
			latex = {
				name = "Latex",
				module = "blink-cmp-latex",
				opts = {
					insert_command = function(ctx)
						local ft = vim.api.nvim_get_option_value("filetype", {
							scope = "local",
							buf = ctx.bufnr,
						})
						if ft == "tex" then return true end
						return false
					end,
				},
			},
			emoji = {
				name = "Emoji",
				module = "blink-emoji",
			},
			thesaurus = {
				name = "blink-cmp-words",
				module = "blink-cmp-words.thesaurus",
			},
			dictionary = {
				name = "blink-cmp-words",
				module = "blink-cmp-words.dictionary",
			},
		},
	},

	snippets = { preset = "luasnip" },

	fuzzy = { implementation = "prefer_rust_with_warning" },
}
