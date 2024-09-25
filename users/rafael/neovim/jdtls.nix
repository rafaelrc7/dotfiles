{ pkgs, ... }: {
  programs.neovim = {
    plugins = let ps = pkgs.vimPlugins; in [ ps.nvim-jdtls ];
    extraPackages = with pkgs; [
      jdt-language-server
      vscode-extensions.vscjava.vscode-java-debug
      vscode-extensions.vscjava.vscode-java-test
    ];
  };

  xdg.configFile."nvim/ftplugin/java.lua".text = /* lua */ ''
    local jdtls = require "jdtls"

    local home_path = vim.env.HOME
    local workspace_path = home_path .. "/.cache/nvim/jdtls-workspace"
    local project_path = vim.fs.root(0,
      { "flake.nix", ".git", "mvnw", "pom.xml", "gradlew", "build.gradle", "Makefile" })
    local data_dir = workspace_path .. project_path

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
    local extendedClientCapabilities = jdtls.extendedClientCapabilities
    extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

    local bundles = {}
    vim.list_extend(bundles, vim.split(vim.fn.glob("${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test/server/*.jar"), "\n"))
    vim.list_extend(
      bundles,
      vim.split(
        vim.fn.glob("${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server/com.microsoft.java.debug.plugin-*.jar"),
        "\n"
      )
    )

    local augroup = vim.api.nvim_create_augroup("jdtls_extra", { clear = true })
    vim.api.nvim_create_autocmd({ "LspAttach" }, {
      buffer = bufnr,
      callback = function()
        local map = function(keys, func, desc)
          if desc then desc = "LSP " .. desc end
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc, silent = true })
        end

        map("<localleader>oi", require('jdtls').organize_imports, "[O]rganise [I]mports")

        require("jdtls").setup_dap({ hotcodereplace = "auto" })
        local status_ok, jdtls_dap = pcall(require, "jdtls.dap")
        if status_ok then
          jdtls_dap.setup_dap_main_class_configs()
        end
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

    local os_config = vim.fn.has "mac" == 1 and "mac" or "linux"

    local config = {
      cmd = {
        "${pkgs.jdk}/bin/java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
    	  "-Dosgi.checkConfiguration=true",
    	  "-Dosgi.sharedConfiguration.area=${pkgs.jdt-language-server}/share/java/jdtls/config_" .. os_config,
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
        "-javaagent:${pkgs.lombok}/share/java/lombok.jar",
        "-jar",
        vim.fn.glob("${pkgs.jdt-language-server}/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
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

  '';
}

