local nvim_lsp = require "lspconfig"

local pid = vim.fn.getpid()

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous [d]iagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next [d]iagnostic" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Add to loclist" })

vim.keymap.set(
	"n",
	"<leader>e",
	function()
		vim.diagnostic.open_float {
			focusable = false,
			close_events = { "BufLeave", "CursorMoved", "InsertEnter" },
			scope = "line",
			severity_sort = true,
			border = "rounded",
			source = true,
		}
	end,
	{ desc = "Open diagnostic float" }
)

local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.g.completion_matching_strategy_list = { "exact", "substring", "fuzzy" }

local formattingAugroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
vim.api.nvim_create_autocmd({ "LspAttach" }, {
	callback = function(ev)
		local bufnr = ev.buf
		local client = vim.lsp.get_client_by_id(ev.data.client_id)

		local map = function(mode, keys, func, desc)
			if desc then desc = "LSP " .. desc end
			vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc, silent = true })
		end

		local format = function(opts)
			if client ~= nil and client.supports_method "textDocument/formatting" then vim.lsp.buf.format(opts) end
		end

		local _, _ = pcall(vim.lsp.codelens.refresh)
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		map("n", "<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
		map("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
		map("n", "gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
		map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
		map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
		map("n", "gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
		map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
		map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
		map(
			"n",
			"<leader>wl",
			function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
			"[W]orkspace [L]ist Folders"
		)
		map("n", "<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
		map("n", "gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
		map("n", "<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
		map("n", "<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
		map("n", "<leader>cl", vim.lsp.codelens.run, "[C]ode [L]ens")
		map("n", "<leader>fr", function() format { async = true, bufnr = bufnr } end, "[F]o[r]mat")
		map({ "n", "v" }, "<leader>cA", vim.lsp.buf.code_action, "[C]ode [A]ction")

		-- Format on save
		vim.api.nvim_clear_autocmds { group = formattingAugroup, buffer = bufnr }
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			callback = function(_) format { bufnr = bufnr } end,
			group = formattingAugroup,
		})
	end,
	group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
})

local function on_attach(_, _) end

-- CLANGD
nvim_lsp.clangd.setup {
	filetypes = { "c", "cpp", "h", "hpp", "objc", "objcpp", "cuda" },
	on_attach = on_attach,
	capabilities = capabilities,
}

-- Rust
nvim_lsp.rust_analyzer.setup {
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
}

-- Elixir
nvim_lsp.elixirls.setup {
	cmd = { "elixir-ls" },
	on_attach = on_attach,
	capabilities = capabilities,
}

-- html
capabilities.textDocument.completion.completionItem.snippetSupport = true

nvim_lsp.html.setup {
	on_attach = on_attach,
	capabilities = capabilities,
}

-- CSS
nvim_lsp.cssls.setup {
	on_attach = on_attach,
	capabilities = capabilities,
}

-- TS
nvim_lsp.tsserver.setup {
	on_attach = on_attach,
	capabilities = capabilities,
}

-- Json
nvim_lsp.jsonls.setup {
	on_attach = on_attach,
	capabilities = capabilities,
}

-- XML
nvim_lsp.lemminx.setup {
	on_attach = on_attach,
	capabilities = capabilities,
}

-- C# (Omnisharp)
nvim_lsp.omnisharp.setup {
	cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(pid) },
	root_dir = nvim_lsp.util.root_pattern("*.csproj", "*.sln"),
	on_attach = on_attach,
	capabilities = capabilities,
}

-- Python (pyright)
nvim_lsp.pyright.setup {
	settings = {
		python = {
			analysis = {
				extraPaths = { ".", "src" },
			},
		},
	},
	on_attach = on_attach,
	capabilities = capabilities,
}

-- Lua
nvim_lsp.lua_ls.setup {
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
}

-- LaTeX (texlab)
nvim_lsp.texlab.setup {
	on_attach = on_attach,
	capabilities = capabilities,
}

-- Vim
nvim_lsp.vimls.setup {
	on_attach = on_attach,
	capabilities = capabilities,
}

-- Nix (nixd)
nvim_lsp.nixd.setup {
	on_attach = on_attach,
	capabilities = capabilities,
}

-- GO (gopls)
nvim_lsp.gopls.setup {
	on_attach = on_attach,
	capabilities = capabilities,
}

-- Racket
nvim_lsp.racket_langserver.setup {
	on_attach = on_attach,
	capabilities = capabilities,
}
