local Rule = require "nvim-autopairs.rule"
local cmp = require "cmp"
local cmp_autopairs = require "nvim-autopairs.completion.cmp"
local cond = require "nvim-autopairs.conds"
local npairs = require "nvim-autopairs"
local ts_conds = require "nvim-autopairs.ts-conds"

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

npairs.setup {
	check_ts = true,
	enable_check_bracket_line = false,
	fast_wrap = {},
}

npairs.get_rules("'")[1].not_filetypes = { "scheme", "lisp" }
require("nvim-autopairs").get_rules("'")[1]:with_pair(function(opts)
	local prev = string.sub(opts.text, 1, opts.col)
	print(string.match(prev, "%w+'*$"))
	return not string.match(prev, "%w+'*$")
end)

npairs.add_rule(Rule("<", ">", {
	"-html",
	"-javascriptreact",
	"-typescriptreact",
}):with_pair(cond.before_regex("%a+:?:?$", 3)):with_move(function(opts) return opts.char == ">" end))
