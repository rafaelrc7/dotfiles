vim.keymap.set(
	"n",
	"K",
	function() vim.cmd.RustLsp { "hover", "actions" } end,
	{ buffer = true, silent = true, desc = "Rust: hover actions" }
)
