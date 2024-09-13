local dap, dapui = require("dap"), require("dapui")
local map = vim.keymap.set
local sign_define = vim.fn.sign_define

dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end

dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end

dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end

dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

map("n", "<Leader>dt", dapui.toggle, { desc = "[D]ap-ui [t]oggle" })
map("n", "<Leader>dr", function()
	dapui.open({ reset = true })
end, { desc = "[D]ap-ui [r]eset" })

map("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Toggle [d]ebug [b]reakpoint" })
map("n", "<Leader>dBB", dap.set_breakpoint, { desc = "Set debug [[b]]reakpoint" })
map("n", "<Leader>dBL", function()
	dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, { desc = "Toggle [b]reakpoint [l]og" })
map("n", "<Leader>dBC", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint Condition: "), nil, nil)
end, { desc = "Toggle [b]reakpoint [c]onditional" })

map("n", "<Leader>dc", dap.continue, { desc = "[D]ebug [c]ontinue" })
map("n", "<Leader>do", dap.step_over, { desc = "[D]ebug step [o]ver" })
map("n", "<Leader>di", dap.step_into, { desc = "[D]ebug step [i]nto" })
map("n", "<Leader>dO", dap.step_out, { desc = "[D]ebug step [o]ut" })

sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint" })
sign_define("DapBreakpointCondition", { text = "", texthl = "DapBreakpoint" })
sign_define("DapLogPoint", { text = "", texthl = "DapBreakpoint" })
sign_define("DapBreakpointRejected", { text = "", texthl = "DapBreakpoint" })
sign_define("DapStopped", { text = "󰁕", texthl = "DapStopped" })

dap.adapters.gdb = {
	type = "executable",
	command = "gdb",
	args = { "-i", "dap" },
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

dap.configurations.rust = {
	{
		name = "Launch",
		type = "gdb",
		request = "launch",
		program = function()
			local cwd = vim.fn.getcwd()
			return vim.fn.input("Path to executable: ", cwd .. "/target/debug/" .. vim.fs.basename(cwd), "file")
		end,
		cwd = "${workspaceFolder}",
		stopAtBeginningOfMainSubprogram = false,
	},
}
