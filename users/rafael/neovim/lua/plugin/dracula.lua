require("dracula").setup {
	-- show the '~' characters after the end of buffers
	show_end_of_buffer = true,

	-- https://github.com/dracula/vim/blob/28874a1e9d583eb0b1dfebb9191445b822812ea3/autoload/dracula.vim
	colors = {
		bg = "#191A21", -- bgdarker
	},

	lualine_bg_color = "#21222C", -- bgdark
}

vim.cmd.colorscheme "dracula"
