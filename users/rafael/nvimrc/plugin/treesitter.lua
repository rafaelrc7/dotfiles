local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

require("nvim-treesitter.configs").setup({
	ensure_installed = {},
	sync_install = false,
	ignore_install = {},
	auto_install = false,

	highlight = {
		enable = true, -- false will disable the whole extension
		disable = function(lang, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,
		additional_vim_regex_highlighting = { "latex", "markdown" },
	},
	indent = {
		enable = true,
	},
	autopairs = {
		enable = true,
	},
})

vim.o.foldmethod = "expr"
vim.cmd("set foldexpr=nvim_treesitter#foldexpr()")
