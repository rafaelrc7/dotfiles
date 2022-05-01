{ inputs, config, pkgs, ... }: {
  home.username = "rafael";
  home.homeDirectory = "/home/rafael";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    discord
    gcc
    librewolf
    python3
    thunderbird
    unityhub
  ];

  xdg.enable = true;
  xdg.userDirs = {
      enable = true;
      createDirectories = true;
  };

  programs.git = {
    enable = true;
    userName = "rafaelrc7";
    userEmail = "rafaelrc7@gmail.com";
    delta.enable = true;
    extraConfig = {
      init.defaultBranch = "master";
      user.editor = "nvim";
      delta.navigate = true;
      merge.conflictStyle = "diff3";
      pull.rebase = true;
    };
    signing = {
      signByDefault = true;
      key = "03F104A08E5D7DFE";
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      editor = "nvim";
      git_protocol = "ssh";
    };
  };

  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.nerdfonts;
      name = "FiraCode Nerd Font Mono";
      size = 12;
    };
    settings = {
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      enable_audio_bell = false;
      scrollback_pager_history_size = 2048;
      mouse_map = "left click ungrabbed no-op";
    };
  };

  programs.neovim = with pkgs; {
    enable = true;

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
      local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

      local function on_attach()
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
        cmd = { "${haskell-language-server}/bin/haskell-language-server-wrapper", "--lsp" },
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
        cmd = {"${nodePackages.typescript-language-server}/bin/tsserver", "--stdio"},
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

      -- Lua (sumneko)
      local runtime_path = vim.split(package.path, ';')
      table.insert(runtime_path, "lua/?.lua")
      table.insert(runtime_path, "lua/?/init.lua")

      nvim_lsp.sumneko_lua.setup {
        cmd = {"${pkgs.nixpkgs-stable.sumneko-lua-language-server}/bin/lua-language-server"},
        on_attach = on_attach,
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
              -- Setup your lua path
              path = runtime_path,
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = {'vim'},
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = {
                [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
              },
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
          },
        },
        capabilities = capabilities,
      };

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
    '';

    extraPackages = [
      fd
      ripgrep
    ];

    plugins = with vimPlugins; [
      nvim-treesitter
      #(nvim-treesitter.withPlugins (plugins: tree-sitter.allGrammars))
      nvim-lspconfig
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      nvim-cmp
      luasnip
      cmp_luasnip
      telescope-nvim
      telescope-fzy-native-nvim
      popup-nvim
      plenary-nvim
      vim-airline
      tmuxline-vim
      vimtex
      markdown-preview-nvim
      symbols-outline-nvim
      nvim-jdtls
      neoformat
      emmet-vim
      nvim-tree-lua
      nvim-web-devicons
      editorconfig-nvim
      vimspector
      undotree
      nerdcommenter
      delimitMate
      vim-dispatch-neovim
      tagbar
      vim-fugitive
      gitsigns-nvim
      gruvbox-nvim
      neorg
      presence-nvim
    ];
  };

  xdg.configFile."nvim/lua" = {
    source = "${inputs.nvim-config}/lua";
  };

  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_KEY = "03F104A08E5D7DFE";
    };
  };

  services.unclutter = {
    enable = true;
    timeout = 3;
  };

  systemd.user.startServices = "sd-switch";
}

