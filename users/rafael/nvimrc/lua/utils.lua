local M = {}

local api = vim.api

function M.nvim_create_augroups(definitions)
	for group_name, definition in pairs(definitions) do
		api.nvim_command("augroup " .. group_name)
		api.nvim_command("autocmd!")
		for _, def in ipairs(definition) do
			local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
			api.nvim_command(command)
		end
		api.nvim_command("augroup END")
	end
end

function M.load_nvim_module(module)
	local ok, ret = pcall(require, module)

	if not ok then
		print(string.format("ERROR: Failed to load the %s module.  %s\n", module, ret))
		return nil
	else
		return ret
	end
end

return M
