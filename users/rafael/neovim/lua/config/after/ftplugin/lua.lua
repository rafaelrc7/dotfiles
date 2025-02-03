vim.b.formatter = function(bufpath, bufnr)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

	local status, proc = pcall(
		vim.system,
		{ "stylua", "--search-parent-directories", "--stdin-filepath", bufpath, "--", "-" },
		{ text = true, stdin = lines }
	)
	if not status then return false end
	local result = proc:wait()

	if result.code == 0 then
		lines = {}
		for line in result.stdout:gmatch "(.-)\n" do
			table.insert(lines, line)
		end

		local saved_view = vim.fn.winsaveview()
		vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
		vim.fn.winrestview(saved_view)
	else
		return false
	end

	return true
end
