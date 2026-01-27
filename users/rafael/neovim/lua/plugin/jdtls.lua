local bufnr = vim.api.nvim_get_current_buf()

local jdtls = require "jdtls"
local jdtls_dap = require "jdtls.dap"

local workspace_path = vim.fn.stdpath "cache" .. "/jdtls-workspace"
local project_path = vim.fs.root(0, { "flake.nix", ".git", "mvnw", "pom.xml", "gradlew", "build.gradle", "Makefile" })
local data_dir = workspace_path .. project_path

local capabilities = vim.lsp.protocol.make_client_capabilities()

local ok, blinkcmp = pcall(require, "blink.cmp")
if ok then capabilities = vim.tbl_deep_extend("force", capabilities, blinkcmp.get_lsp_capabilities({}, false)) end

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local bundles = {}
vim.list_extend(
	bundles,
	vim.split(vim.fn.glob "@vscode-java-test@/share/vscode/extensions/vscjava.vscode-java-test/server/*.jar", "\n")
)
vim.list_extend(
	bundles,
	vim.split(
		vim.fn.glob "@vscode-java-debug@/share/vscode/extensions/vscjava.vscode-java-debug/server/com.microsoft.java.debug.plugin-*.jar",
		"\n"
	)
)

local augroup = vim.api.nvim_create_augroup("jdtls_extra", { clear = true })
vim.api.nvim_create_autocmd({ "LspAttach" }, {
	buffer = bufnr,
	callback = function()
		local opts = function(desc) return { buffer = bufnr, silent = true, desc = desc and ("JDTLS: " .. desc) or nil } end
		vim.keymap.set("n", "<A-o>", jdtls.organize_imports, opts "[O]rganise Imports")

		local _, _ = pcall(vim.lsp.codelens.refresh)

		-- Enable nvim-dap
		jdtls.setup_dap { hotcodereplace = "auto", config_overrides = {} }
		jdtls_dap.setup_dap_main_class_configs()
	end,
	group = augroup,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	buffer = bufnr,
	callback = function()
		local _, _ = pcall(vim.lsp.codelens.refresh)
	end,
	group = augroup,
})

local os_config

if vim.fn.has "mac" == 1 then
	os_config = "mac"
elseif vim.fn.has "unix" then
	os_config = "linux"
elseif vim.fn.has "win32" then
	os_config = "win"
else
	vim.notify("JDTLS: Unknown OS", vim.log.levels.ERROR)
	return
end

local config = {
	cmd = {
		"@jdk@",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dosgi.checkConfiguration=true",
		"-Dosgi.sharedConfiguration.area=@jdtls@/share/java/jdtls/config_" .. os_config,
		"-Dosgi.sharedConfiguration.area.readOnly=true",
		"-Dosgi.configuration.cascaded=true",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xms1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-javaagent:@lombok@/share/java/lombok.jar",
		"-jar",
		vim.fn.glob "@jdtls@/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*.jar",
		"-data",
		data_dir,
	},

	root_dir = project_path,
	capabilities = capabilities,

	settings = {
		java = {
			eclipse = {
				downloadSources = true,
			},
			configuration = {
				updateBuildConfiguration = "interactive",
			},
			maven = {
				downloadSources = true,
			},
			referencesCodeLens = {
				enabled = true,
			},
			references = {
				includeDecompiledSources = true,
			},
			sources = {
				organizeImports = {
					starThreshold = 5,
					staticStarThreshold = 5,
				},
			},
			inlayHints = {
				parameterNames = {
					enabled = "all", -- literals, all, none
				},
			},
			format = {
				enabled = true,
			},
		},
		signatureHelp = { enabled = true },
		extendedClientCapabilities = extendedClientCapabilities,
	},
	init_options = {
		bundles = bundles,
	},
}

jdtls.start_or_attach(config)
