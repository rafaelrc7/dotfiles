local project_root = vim.fs.root(0, "project.godot")

if project_root ~= nil then
	local server_pipe_path = project_root .. "/neovim-server.pipe"
	local is_server_running = vim.uv.fs_stat(server_pipe_path)
	if not is_server_running then vim.fn.serverstart(server_pipe_path) end
end
