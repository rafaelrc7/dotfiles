local formattingAugroup = vim.api.nvim_create_augroup("LspFormatting", { clear = false })

local function on_attach(client, bufnr)
	local format = function()
		if client.supports_method "textDocument/formatting" then vim.lsp.buf.format { bufnr = bufnr } end
	end

	local map = function(keys, func, desc)
		if desc then desc = "LSP: " .. desc end
		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc, silent = true })
	end

	local _, _ = pcall(vim.lsp.codelens.refresh)

	map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	map("<leader>cA", vim.lsp.buf.code_action, "[C]ode [A]ction")
	map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	map("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	map("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
	map("<leader>cl", vim.lsp.codelens.run, "[C]ode [L]ens")

	map("K", vim.lsp.buf.hover, "Hover Documentation")
	map("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	map("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	map(
		"<leader>wl",
		function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
		"[W]orkspace [L]ist Folders"
	)

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(
		bufnr,
		"Format",
		function(_) format() end,
		{ desc = "Format current buffer with LSP" }
	)

	-- Format on save
	vim.api.nvim_clear_autocmds { group = formattingAugroup, buffer = bufnr }
	vim.api.nvim_create_autocmd("BufWritePre", {
		buffer = bufnr,
		callback = function(_) format() end,
		group = formattingAugroup,
	})
end

local function on_attach_builder(fun)
	return function(client, bufnr)
		on_attach(client, bufnr)
		if fun ~= nil then fun(client, bufnr) end
	end
end

return on_attach_builder
