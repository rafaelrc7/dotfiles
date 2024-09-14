local api = vim.api

-- nvim-lsp
local nvim_lsp = require("lspconfig")

local pid = vim.fn.getpid()
local home_dir = os.getenv("HOME")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous [d]iagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next [d]iagnostic" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Add to loclist" })

vim.keymap.set("n", "<leader>e", function()
	vim.diagnostic.open_float({
		focusable = false,
		close_events = { "BufLeave", "CursorMoved", "InsertEnter" },
		scope = "line",
		severity_sort = true,
		border = "rounded",
		source = true,
	})
end, { desc = "Open diagnostic float" })

local function on_attach(_, bufnr)
	local map = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc, silent = true })
	end

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
	map("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		if vim.lsp.buf.format then
			vim.lsp.buf.format()
		elseif vim.lsp.buf.formatting then
			vim.lsp.buf.formatting()
		end
	end, { desc = "Format current buffer with LSP" })
end

local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.g.completion_matching_strategy_list = { "exact", "substring", "fuzzy" }

-- CLANGD
nvim_lsp.clangd.setup({
	filetypes = { "c", "cpp", "h", "hpp", "objc", "objcpp", "cuda" },
	on_attach = on_attach,
	capabilities = capabilities,
})

-- Rust
nvim_lsp.rust_analyzer.setup({
	settings = {
		["rust-analyzer"] = {
			check = {
				command = "clippy",
				features = "all",
			},
		},
	},
	on_attach = on_attach,
	capabilities = capabilities,
})

-- Elixir
nvim_lsp.elixirls.setup({
	cmd = { "elixir-ls" },
	on_attach = on_attach,
	capabilities = capabilities,
})

-- html
capabilities.textDocument.completion.completionItem.snippetSupport = true

nvim_lsp.html.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- CSS
nvim_lsp.cssls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- TS
nvim_lsp.tsserver.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- Json
nvim_lsp.jsonls.setup({
	commands = {
		Format = {
			function()
				vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
			end,
		},
	},
	on_attach = on_attach,
	capabilities = capabilities,
})

-- C# (Omnisharp)
nvim_lsp.omnisharp.setup({
	cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(pid) },
	root_dir = nvim_lsp.util.root_pattern("*.csproj", "*.sln"),
	on_attach = on_attach,
	capabilities = capabilities,
})

-- Python (pyright)
nvim_lsp.pyright.setup({
	settings = {
		python = {
			analysis = {
				extraPaths = { ".", "src" },
			},
		},
	},
	on_attach = on_attach,
	capabilities = capabilities,
})

-- Lua
nvim_lsp.lua_ls.setup({
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
	on_attach = on_attach,
	capabilities = capabilities,
})

-- LaTeX (texlab)
nvim_lsp.texlab.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- Vim
nvim_lsp.vimls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- Nix (nixd)
nvim_lsp.nixd.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- GO (gopls)
nvim_lsp.gopls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- Racket
nvim_lsp.racket_langserver.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})
