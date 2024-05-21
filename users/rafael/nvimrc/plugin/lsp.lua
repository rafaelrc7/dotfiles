local api = vim.api

-- nvim-lsp
local nvim_lsp = require("lspconfig")
local pid = vim.fn.getpid()
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local home_dir = os.getenv("HOME")

local function on_attach()
	vim.api.nvim_create_autocmd("CursorHold", {
		buffer = bufnr,
		callback = function()
			local opts = {
				focusable = false,
				close_events = { "BufLeave", "CursorMoved", "InsertEnter" },
				border = "rounded",
				source = "always",
				prefix = " ",
				scope = "cursor",
			}
			vim.diagnostic.open_float(nil, opts)
		end,
	})
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

-- Haskell (hls)
nvim_lsp.hls.setup({
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

local lspDiagnosticGroup = api.nvim_create_augroup("lsp_diagnostic_float", { clear = true })
api.nvim_create_autocmd("CursorHold", {
	pattern = "*",
	callback = function(_)
		vim.diagnostic.open_float()
	end,
	group = lspDiagnosticGroup,
})
