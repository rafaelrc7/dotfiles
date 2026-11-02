local programs = require("hyprlandrc.common.globals").programs
local exec_cmd = require("hyprlandrc.common.utils").exec_cmd

hl.workspace_rule { workspace = "10", monitor = "desc:LG Electronics LG FULL HD 0x01010101", default = true }

-- Setup default programs for empty workspaces
local workspace_default_program = {
	["special:scratchpad"] = programs.terminal,
	["special:calculator"] = programs.calculator,
	["special:screen-record"] = "gpu-screen-recorder-gtk",
}

hl.on("workspace.created", function(ws)
	if not ws.is_empty then return end

	local program = workspace_default_program[ws.name]
	if not program then return end

	exec_cmd(program, { workspace = ws.name .. " silent" })
end)
