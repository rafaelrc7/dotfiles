local M = {}

local exec_cmd_prefix = require("hyprlandrc.common.globals").exec_prefix

function M.prefix_cmd(cmd) return exec_cmd_prefix .. cmd end
function M.exec_cmd(cmd, rules) return hl.exec_cmd(M.prefix_cmd(cmd), rules) end
function M.dsp_exec_cmd(cmd, rules) return hl.dsp.exec_cmd(M.prefix_cmd(cmd), rules) end

function M.join_strings(strings, separator)
	separator = separator or ","
	strings = strings or {}

	if #strings == 0 then return "" end
	local joined_string = strings[1]
	for i, string in ipairs(strings) do
		if i ~= 1 then joined_string = joined_string .. separator .. string end
	end
	return joined_string
end

return M
