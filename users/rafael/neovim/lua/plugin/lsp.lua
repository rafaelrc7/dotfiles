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
		local bufnr = ev.buf

		local bufmap = function(mode, rhs, lhs, desc)
			if desc then desc = "LSP " .. desc end
			vim.keymap.set(mode, rhs, lhs, { buffer = bufnr, desc = desc, silent = true })
		end

		local _, _ = pcall(vim.lsp.codelens.refresh)
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		vim.keymap.set(
			"n",
			"[d",
			function() vim.diagnostic.jump { count = -1, float = true } end,
			{ desc = "Previous [d]iagnostic" }
		)
		vim.keymap.set(
			"n",
			"]d",
			function() vim.diagnostic.jump { count = 1, float = true } end,
			{ desc = "Next [d]iagnostic" }
		)
		vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Add to loclist" })

		bufmap("n", "<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
		bufmap("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
		bufmap("n", "gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
		bufmap("n", "K", vim.lsp.buf.hover, "Hover Documentation")
		bufmap("n", "<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
		bufmap("n", "gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
		bufmap("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
		bufmap("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
		bufmap(
			"n",
			"<leader>wl",
			function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
			"[W]orkspace [L]ist Folders"
		)
		bufmap("n", "<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
		bufmap("n", "gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
		bufmap("n", "<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
		bufmap("n", "<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
		bufmap("n", "<leader>cl", vim.lsp.codelens.run, "[C]ode [L]ens")
		bufmap({ "n", "v" }, "<leader>cA", vim.lsp.buf.code_action, "[C]ode [A]ction")

		-- Code actions
		require("actions-preview").setup {
			require("actions-preview.highlight").delta "delta --no-gitconfig --side-by-side",
		}
		bufmap({ "v", "n" }, "<leader>ca", require("actions-preview").code_actions, "[C]ode [a]ctions")
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
