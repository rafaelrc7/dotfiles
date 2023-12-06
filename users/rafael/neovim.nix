{ inputs, config, pkgs, ... }: {
  programs.neovim = with pkgs; {
    enable = true;

    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = true;
    withNodeJs = true;

    extraConfig =''
      lua << EOF
      require('init')

      -- LSP
      local utils = require "utils"
      local nvim_lsp = require "lspconfig"
      local pid = vim.fn.getpid()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local function on_attach()
        vim.api.nvim_create_autocmd("CursorHold", {
          buffer = bufnr,
          callback = function()
            local opts = {
              focusable = false,
              close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
              border = 'rounded',
              source = 'always',
              prefix = ' ',
              scope = 'cursor',
            }
            vim.diagnostic.open_float(nil, opts)
          end
        })
      end

      vim.g.completion_matching_strategy_list = {"exact", "substring", "fuzzy"};

      -- CLANGD
      nvim_lsp.clangd.setup {
        cmd = { "${clang-tools}/bin/clangd" },
        on_attach = on_attach,
        filetypes = { "c", "cpp", "h", "hpp", "objc", "objcpp", "cuda" },
        root_dir = function() return vim.loop.cwd() end,
        capabilities = capabilities,
      };

      -- Rust
      nvim_lsp.rust_analyzer.setup{
        cmd = { "${rust-analyzer}/bin/rust-analyzer" },
        on_attach=on_attach,
        capabilities = capabilities,
      };

      -- Elixir
      nvim_lsp.elixirls.setup{
        cmd = { "${elixir_ls}/bin/elixir-ls" },
        on_attach = on_attach,
        capabilities = capabilities,
      };

      -- Haskell (hls)
      nvim_lsp.hls.setup{
        cmd = { vim.fn.executable("haskell-language-server-wrapper") == 1 and "haskell-language-server-wrapper" or "${haskell-language-server}/bin/haskell-language-server-wrapper", "--lsp" },
        on_attach = on_attach,
        capabilities = capabilities,
      };

      -- html
      capabilities.textDocument.completion.completionItem.snippetSupport = true;

      nvim_lsp.html.setup {
        cmd = {"${nodePackages.vscode-langservers-extracted}/bin/vscode-html-language-server", "--stdio"},
        on_attach = on_attach,
        capabilities = capabilities,
      };

      -- CSS
      nvim_lsp.cssls.setup {
        cmd = {"${nodePackages.vscode-langservers-extracted}/bin/vscode-css-language-server", "--stdio"},
        on_attach = on_attach,
        capabilities = capabilities,
      }

      -- TS
      nvim_lsp.tsserver.setup{
        cmd = {"${nodePackages.typescript-language-server}/bin/typescript-language-server", "--stdio"},
        on_attach=on_attach,
        capabilities = capabilities,
      };

      -- Json
      nvim_lsp.jsonls.setup {
        cmd = {"${nodePackages.vscode-langservers-extracted}/bin/vscode-json-language-server", "--stdio"},
        on_attach = on_attach,
        commands = {
          Format = {
            function()
              vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0});
            end
          },
        },
        capabilities = capabilities,
      };

      -- C# (Omnisharp)
      nvim_lsp.omnisharp.setup{
        cmd = { "${omnisharp-roslyn}/bin/omnisharp", "--languageserver" , "--hostPID", tostring(pid) },
        on_attach = on_attach,
        root_dir = nvim_lsp.util.root_pattern("*.csproj","*.sln"),
        capabilities = capabilities,
      };

      -- Python (pyright)
      nvim_lsp.pyright.setup{
        cmd = {"${pyright}/bin/pyright-langserver", "--stdio"},
        on_attach = on_attach,
        settings = {
          python = {
            analysis = {
              extraPaths = {".", "src"},
            },
          },
        },
        capabilities = capabilities,
      };

      -- Lua
      require'lspconfig'.lua_ls.setup {
        cmd = {"${sumneko-lua-language-server}/bin/lua-language-server"},
      	on_attach = on_attach,
      	settings = {
      		Lua = {
      			runtime = {
      				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
      				version = 'LuaJIT',
      			},
      			diagnostics = {
      				-- Get the language server to recognize the `vim` global
      				globals = {'vim'},
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
      	capabilities = capabilities,
      }

      -- LaTeX (texlab)
      nvim_lsp.texlab.setup{
        cmd = { "${texlab}/bin/texlab" },
        on_attach = on_attach,
        capabilities = capabilities,
      };

      -- Vim
      nvim_lsp.vimls.setup{
        cmd = { "${nodePackages.vim-language-server}/bin/vim-language-server" },
        on_attach = on_attach,
        capabilities = capabilities,
      };

      -- Nix (rnix-lsp)
      nvim_lsp.rnix.setup{
        cmd = { "${rnix-lsp}/bin/rnix-lsp" },
        on_attach = on_attach,
        capabilities = capabilities,
      };

      -- GO (gopls)
      nvim_lsp.gopls.setup{
        cmd = { "${gopls}/bin/gopls" },
        on_attach = on_attach,
        capabilities = capabilities,
      };

      utils.nvim_create_augroups(
        {
          lspconfig = {
            {"CursorHold", "*", "lua vim.diagnostic.open_float()"},

            -- Java (jdtls)
            {"FileType", "java", "lua require('jdtls').start_or_attach({cmd = {'jdtls.sh'}})"}
          },
        }
      );
      EOF

      set background=dark
      colorscheme gruvbox
      au FileType * silent! LspStart
    '';

    extraPackages = [
      fd
      ripgrep
      clang
    ];

    plugins = with vimPlugins; [
      nvim-treesitter.withAllGrammars
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-rg
      cmp-treesitter
      luasnip
      cmp_luasnip
      telescope-nvim
      telescope-fzy-native-nvim
      plenary-nvim
      vimtex
      markdown-preview-nvim
      symbols-outline-nvim
      nvim-jdtls
      neoformat
      emmet-vim
      nvim-tree-lua
      nvim-web-devicons
      vimspector
      undotree
      nerdcommenter
      nvim-autopairs
      tagbar
      vim-fugitive
      gitsigns-nvim
      gruvbox-nvim
      nord-nvim
      neorg
      presence-nvim
      lualine-nvim
      lualine-lsp-progress
    ];
  };

  xdg.configFile."nvim/lua" = {
    source = "${inputs.nvim-config}/lua";
  };
}

