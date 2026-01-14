local dap, dapui = require "dap", require "dapui"

dap.listeners.before.attach.dapui_config = function() dapui.open() end

dap.listeners.before.launch.dapui_config = function() dapui.open() end

dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end

dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

vim.keymap.set("n", "<Leader>dt", dapui.toggle, { desc = "[D]ap-ui [t]oggle" })
vim.keymap.set("n", "<Leader>dr", function() dapui.open { reset = true } end, { desc = "[D]ap-ui [r]eset" })

vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Toggle [d]ebug [b]reakpoint" })
vim.keymap.set("n", "<Leader>dBB", dap.set_breakpoint, { desc = "Set debug [[b]]reakpoint" })
vim.keymap.set(
	"n",
	"<Leader>dBL",
	function() dap.set_breakpoint(nil, nil, vim.fn.input "Log point message: ") end,
	{ desc = "Toggle [b]reakpoint [l]og" }
)
vim.keymap.set(
	"n",
	"<Leader>dBC",
	function() dap.set_breakpoint(vim.fn.input "Breakpoint Condition: ", nil, nil) end,
	{ desc = "Toggle [b]reakpoint [c]onditional" }
)

vim.keymap.set("n", "<Leader>dc", dap.continue, { desc = "[D]ebug [c]ontinue" })
vim.keymap.set("n", "<Leader>do", dap.step_over, { desc = "[D]ebug step [o]ver" })
vim.keymap.set("n", "<Leader>di", dap.step_into, { desc = "[D]ebug step [i]nto" })
vim.keymap.set("n", "<Leader>dO", dap.step_out, { desc = "[D]ebug step [o]ut" })
vim.keymap.set("n", "<Leader>dK", dap.terminate, { desc = "[D]ebug [K]ill" })

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DapBreakpoint" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DapBreakpoint" })
vim.fn.sign_define("DapStopped", { text = "󰁕", texthl = "DapStopped" })

dap.adapters.gdb = {
	type = "executable",
	command = "gdb",
	args = { "-i", "dap" },
}

dap.adapters.lldb = {
	type = "server",
	port = "${port}",
	executable = {
		command = "codelldb",
		args = { "--port", "${port}" },
	},
}

local cxxConfig = {
	name = "Launch",
	type = "gdb",
	request = "launch",
	program = function()
		local cwd = vim.fn.getcwd()
		return vim.fn.input("Path to executable: ", cwd .. "/bin/" .. vim.fs.basename(cwd), "file")
	end,
	cwd = "${workspaceFolder}",
	stopAtBeginningOfMainSubprogram = false,
}

dap.configurations.c = {
	cxxConfig,
}

dap.configurations.cpp = {
	cxxConfig,
}

dap.adapters.haskell = {
	type = "executable",
	command = "haskell-debug-adapter",
}
