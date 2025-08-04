return {
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = {
					vim.env.VIMRUNTIME,
				},
			},
			format = {
				enable = false,
				defaultConfig = {
					charset = "utf-8",
					max_line_length = "120",
					end_of_line = "lf",
					insert_final_newline = "true",
					trim_trailing_whitespace = "true",
					indent_style = "tab",
					indent_size = "4",
					tab_width = "4",
					continuation_indent = "4",
					quote_style = "double",
					table_separator_style = "comma",
					trailing_table_separator = "smart",
					call_arg_parentheses = "remove",
					space_after_comment_dash = "true",
					end_statement_with_semicolon = "same_line",
				},
			},
			telemetry = { enable = false },
		},
	},
}
