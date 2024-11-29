local nvim_lsp = require "lspconfig"

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
			if client ~= nil and client.supports_method "textDocument/formatting" then
				vim.lsp.buf.format(opts)
				vim.diagnostic.show(nil, bufnr)
			end
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
		map("n", "<leader>af", function()
			vim.b.do_not_format = not vim.b.do_not_format
			vim.notify("Autoformat on save was " .. (vim.b.do_not_format and "DISABLED" or "ENABLED"),
				vim.log.levels.INFO)
		end, "Toggle [a]uto [f]ormat for current buffer")
		map({ "n", "v" }, "<leader>cA", vim.lsp.buf.code_action, "[C]ode [A]ction")

		-- Format on save
		vim.api.nvim_clear_autocmds { group = formattingAugroup, buffer = bufnr }
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			callback = function(_)
				if vim.b.do_not_format then
					return
				end

				format { bufnr = bufnr }
			end,
			group = formattingAugroup,
		})

		-- Code actions
		require("actions-preview").setup {
			require("actions-preview.highlight").delta "${pkgs.delta}/bin/delta --no-gitconfig --side-by-side",
		}
		map({ "v", "n" }, "<leader>ca", require("actions-preview").code_actions, "[C]ode [a]ctions")
	end,
	group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
})

local function get_default_capabilities()
	return require "cmp_nvim_lsp".default_capabilities(vim.lsp.protocol.make_client_capabilities())
end

local function on_attach(_, _) end
local default_capabilities = get_default_capabilities()

-- html/css/json
local vscode_langservers_capabilities = get_default_capabilities()
vscode_langservers_capabilities.textDocument.completion.completionItem.snippetSupport = true

local lsps = {
	"angularls",
	"asm_lsp",
	"autotools_ls",
	"bashls",
	"cmake",
	"docker_compose_language_service",
	"dockerls",
	"emmet_language_server",
	"eslint",
	"glsl_analyzer",
	"gopls",
	"gradle_ls",
	"kotlin_language_server",
	"lemminx",
	"nixd",
	"postgres_lsp",
	"prolog_ls",
	"racket_langserver",
	"scheme_langserver",
	"texlab",
	"vimls",
	arduino_language_server = {
		capabilities = vim.tbl_extend("force", get_default_capabilities(), {
			textDocument = { semanticTokens = vim.NIL },
			workspace = { semanticTokens = vim.NIL },
		}),
	},
	clangd = {
		capabilities = vim.tbl_extend("force", get_default_capabilities(), {
			offsetEncoding = { "utf-8" },
		}),
	},
	cssls = { capabilities = vscode_langservers_capabilities },
	elixirls = { cmd = { "elixir-ls" } },
	html = { capabilities = vscode_langservers_capabilities },
	jsonls = { capabilities = vscode_langservers_capabilities },
	lua_ls = {
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
					library = {
						vim.env.VIMRUNTIME,
					},
				},
				format = {
					enable = true,
					defaultConfig = {
						charset = "utf-8",
						max_line_length = "120",
						end_of_line = "lf",
						insert_final_newline = "true",
						trim_trailing_whitespace = "true",
						indent_style = "tab",
						indent_size = "4",
						tab_width = "4",
						continuation_indent = "4",
						quote_style = "double",
						table_separator_style = "comma",
						trailing_table_separator = "smart",
						call_arg_parentheses = "remove",
						space_after_comment_dash = "true",
						end_statement_with_semicolon = "same_line",
					},
				},
				-- Do not send telemetry data containing a randomized but unique identifier
				telemetry = { enable = false },
			},
		},
	},
	omnisharp = { cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) } },
	pyright = {
		settings = {
			python = {
				analysis = {
					extraPaths = { ".", "src" },
					autoSearchPaths = true,
					diagnosticMode = "openFilesOnly",
					useLibraryCodeForTypes = true,
				},
			},
		},
	},
}

local function lsp_setup(lsp, extra_settings)
	local settings = { on_attach = on_attach, capabilities = default_capabilities }
	nvim_lsp[lsp].setup(vim.tbl_extend("force", settings, extra_settings))
end

for k, v in pairs(lsps) do
	if type(k) == "number" then
		lsp_setup(v, {})
	elseif type(k) == "string" then
		lsp_setup(k, v)
	end
end
