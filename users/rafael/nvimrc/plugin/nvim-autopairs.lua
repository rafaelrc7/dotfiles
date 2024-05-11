local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

require("nvim-autopairs").setup({
	check_ts = true,
	fast_wrap = {},
})

require("nvim-autopairs.ts-conds")
