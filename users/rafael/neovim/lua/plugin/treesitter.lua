local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
local parsers = require "nvim-treesitter.parsers"
local queries = require "nvim-treesitter.query"

require("nvim-treesitter.configs").setup {
	ensure_installed = {},
	sync_install = false,
	ignore_install = {},
	auto_install = false,

	highlight = {
		enable = true, -- false will disable the whole extension
		disable = function(lang, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then return true end
		end,
		additional_vim_regex_highlighting = { "latex", "markdown" },
	},
	indent = {
		enable = true,
	},
	autopairs = {
		enable = true,
	},
}

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("treesitter_fold_enable", { clear = true }),
	callback = function()
		if queries.has_folds(parsers.get_buf_lang()) then
			vim.opt_local.foldmethod = "expr"
			vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		end
	end,
})
