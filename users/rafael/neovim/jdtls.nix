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
        local jdtls = require("jdtls")

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

        local function on_attach(client, bufnr)
          local map = function(keys, func, desc)
            if desc then
              desc = "LSP: " .. desc
            end

            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
          end

          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
          map("<leader>cA", vim.lsp.buf.code_action, "[C]ode [A]ction")
          map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
          map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
          map("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
          map("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
          map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
          map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

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

          -- Setup DAP
          local _, _ = pcall(vim.lsp.codelens.refresh)
          require("jdtls").setup_dap({ hotcodereplace = "auto" })
        end

    	  augroup = vim.api.nvim_create_augroup("jdtls_extra", { clear = true }),
        vim.api.nvim_create_autocmd({ "LspAttach" }, {
          buffer = bufnr,
          callback = function(args)
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

        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function(ev)
              vim.lsp.buf.format({ bufnr = ev.buf, })
            end,
            group = augroup,
          })
        end

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
          on_attach = on_attach,

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

