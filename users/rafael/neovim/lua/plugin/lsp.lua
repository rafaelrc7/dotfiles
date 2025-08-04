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

vim.diagnostic.config {
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚",
			[vim.diagnostic.severity.WARN] = "󰀪",
			[vim.diagnostic.severity.HINT] = "󰌶",
			[vim.diagnostic.severity.INFO] = "",
		},
	},
}

vim.g.completion_matching_strategy_list = { "exact", "substring", "fuzzy" }

vim.api.nvim_create_autocmd({ "LspAttach" }, {
	callback = function(ev)
		local id = vim.tbl_get(ev, "data", "client_id")
		local client = id and vim.lsp.get_client_by_id(id)

		local bufnr = ev.buf

		local bufmap = function(mode, lhs, rhs, desc)
			if desc then desc = "LSP " .. desc end
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
		end

		local client_supports = function(method) return client ~= nil and client:supports_method(method) end

		local _, _ = pcall(vim.lsp.codelens.refresh)
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		if client_supports "textDocument/inlayHint" then vim.lsp.inlay_hint.enable(true, { bufnr = bufnr }) end

		bufmap("n", "[d", function() vim.diagnostic.jump { count = -1, float = true } end, "Previous [d]iagnostic")
		bufmap("n", "]d", function() vim.diagnostic.jump { count = 1, float = true } end, "Next [d]iagnostic")
		bufmap("n", "<leader>q", vim.diagnostic.setloclist, "Add diagnostics to loclist")

		bufmap("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
		bufmap("n", "gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
		bufmap("n", "K", vim.lsp.buf.hover, "Hover Documentation")
		bufmap("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
		bufmap("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
		bufmap(
			"n",
			"<leader>wl",
			function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
			"[W]orkspace [L]ist Folders"
		)
		bufmap("n", "<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
		bufmap("n", "<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
		bufmap("n", "<leader>cl", vim.lsp.codelens.run, "[C]ode [L]ens")
		bufmap({ "n", "v" }, "<leader>cA", vim.lsp.buf.code_action, "[C]ode [A]ction")

		-- Code actions
		require("actions-preview").setup {
			highlight_command = {
				require("actions-preview.highlight").delta "delta --no-gitconfig --side-by-side",
				require("actions-preview.highlight").diff_highlight(),
			},
		}
		bufmap({ "v", "n" }, "grp", require("actions-preview").code_actions, "Code actions [p]review")
	end,
	group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
})

local function on_attach(_, _) end

local lsps = {
	"angularls",
	"arduino_language_server",
	"asm_lsp",
	"autotools_ls",
	"bashls",
	"clangd",
	"cmake",
	"cssls",
	"docker_compose_language_service",
	"dockerls",
	"elixirls",
	"emmet_language_server",
	"eslint",
	"glsl_analyzer",
	"gopls",
	"gradle_ls",
	"html",
	"jsonls",
	"kotlin_language_server",
	"lemminx",
	"lua_ls",
	"nixd",
	"omnisharp",
	"postgres_lsp",
	"prolog_ls",
	"pyright",
	"racket_langserver",
	"scheme_langserver",
	"texlab",
	"vimls",
}

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
for _, v in pairs(lsps) do
	vim.lsp.config(v, {
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

vim.lsp.enable(lsps)
