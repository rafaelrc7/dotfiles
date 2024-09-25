vim.api.nvim_create_autocmd("BufWritePre", {
	buffer = 0,
	callback = function(ev)
		local saved_view = vim.fn.winsaveview()

		local lines = vim.api.nvim_buf_get_lines(ev.buf, 0, -1, false)
		local gofmt = vim.system({ "gofmt" }, { text = true, stdin = lines }):wait()

		if gofmt.code == 0 then
			lines = {}
			for line in gofmt.stdout:gmatch "(.-)\n" do
				table.insert(lines, line)
			end

			vim.api.nvim_buf_set_lines(ev.buf, 0, -1, false, lines)
		elseif gofmt.stderr ~= nil then
			lines = {}
			local err = gofmt.stderr:gsub("<standard input>", vim.fn.expand "%")
			for line in err:gmatch "(.-)\n" do
				table.insert(lines, line)
			end

			vim.fn.setqflist({}, " ", { bufnr = ev.buf, lines = lines })
		end

		vim.fn.winrestview(saved_view)
	end,
	group = vim.api.nvim_create_augroup("gofmt", { clear = true }),
})
