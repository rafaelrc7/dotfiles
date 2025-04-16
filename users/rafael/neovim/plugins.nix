{ pkgs, ... }:
let
in
{
  programs.neovim.plugins =
    let
      ps = pkgs.vimPlugins;
    in
    [
      # Dependencies from multiple plugins
      ps.plenary-nvim
      ps.nui-nvim
      ps.nvim-nio

      ps.which-key-nvim

      {
        plugin = ps.firenvim;
        type = "lua";
        config = # lua
          ''
            if vim.g.started_by_firenvim then
              vim.g.firenvim_config = {
                globalSettings = {
                  priority = 0,
                  cmdline = "neovim",
                  messages = "neovim",
                },
                localSettings = {
                  [".*"] = {
                    priority = 0,
                    content = "text",
                    cmdline = "neovim",
                    messages = "neovim",
                    selector = "textarea",
                    takeover = "never",
                  },
                },
              }
            end
          '';
      }

      {
        plugin = ps.nvim-cmp;
        type = "lua";
        config = builtins.readFile ./lua/plugin/cmp.lua;
      }
      {
        plugin = ps.cmp-git;
        type = "lua";
        config = # lua
          ''
            require("cmp_git").setup()
          '';
      }
      ps.cmp-buffer
      ps.cmp-cmdline
      ps.cmp-conjure
      ps.cmp_luasnip
      ps.cmp-nvim-lsp
      ps.cmp-path
      ps.cmp-treesitter

      ps.luasnip

      {
        plugin = ps.nvim-lspconfig;
        type = "lua";
        config = builtins.readFile ./lua/plugin/lsp.lua;
      }
      ps.actions-preview-nvim

      {
        plugin = ps.nvim-autopairs;
        type = "lua";
        config = builtins.readFile ./lua/plugin/nvim-autopairs.lua;
      }

      {
        plugin = ps.nvim-ts-autotag;
        type = "lua";
        config = # lua
          ''
            require "nvim-ts-autotag".setup {}
          '';
      }

      {
        plugin = ps.telescope-nvim;
        type = "lua";
        config = builtins.readFile ./lua/plugin/telescope.lua;
      }
      ps.telescope-fzf-native-nvim
      ps.telescope-ui-select-nvim

      {
        plugin = ps.gitsigns-nvim;
        type = "lua";
        config = builtins.readFile ./lua/plugin/gitsigns.lua;
      }

      {
        plugin = ps.trouble-nvim;
        type = "lua";
        config = builtins.readFile ./lua/plugin/trouble.lua;
      }

      {
        plugin = ps.vimtex;
        type = "lua";
        config = # lua
          ''
            vim.g.tex_flavor = "latex"
            vim.g.vimtex_view_method = "zathura"
          '';
      }

      {
        plugin = ps.oil-nvim;
        type = "lua";
        config = # lua
          ''
            local oil = require("oil")
            oil.setup()
            vim.keymap.set("n", "-", oil.open, { desc = "Open parent directory" })
          '';
      }

      {
        plugin = ps.nvim-highlight-colors;
        type = "lua";
        config = # lua
          ''
            require("nvim-highlight-colors").setup({})
          '';
      }

      {
        plugin = ps.vim-fugitive;
        type = "lua";
        config = # lua
          ''
            vim.api.nvim_set_keymap("n", "<leader>gs", ":G<CR>", { silent = true, desc = "[G]it [s]tatus" }) -- git status
            vim.api.nvim_set_keymap("n", "<leader>gdh", ":diffget //2<CR>", { silent = true, desc = "[G]it [d]iff left ([h])" })
            vim.api.nvim_set_keymap("n", "<leader>gdl", ":diffget //3<CR>", { silent = true, desc = "[G]it [d]iff right ([l])" })
          '';
      }

      {
        plugin = ps.nvim-navic;
        type = "lua";
        config = # lua
          ''
            require("nvim-navic").setup({
              highlight = true,
              lsp = { auto_attach = true, },
            })
          '';
      }

      {
        plugin = ps.lualine-nvim;
        type = "lua";
        config = builtins.readFile ./lua/plugin/lualine.lua;
      }

      {
        plugin = ps.bufferline-nvim;
        type = "lua";
        config = # lua
          ''
            require("bufferline").setup({})
          '';
      }

      {
        plugin = ps.vim-illuminate;
        type = "lua";
        config = # lua
          ''
            require("illuminate").configure({
              filetypes_denylist = { "dirbuf", "dirvish", "fugitive", "NvimTree", },
            })
          '';
      }

      {
        plugin = ps.toggleterm-nvim;
        type = "lua";
        config = builtins.readFile ./lua/plugin/toggleterm.lua;
      }

      {
        plugin = ps.nvim-dap-ui;
        type = "lua";
        config = # lua
          ''
            require("dapui").setup()
          '';
      }

      {
        plugin = ps.nvim-dap;
        type = "lua";
        config =
          (builtins.readFile ./lua/plugin/dap.lua)
          # lua
          + ''
            require("dap").adapters.gdb.command = "${pkgs.gdb}/bin/gdb"
            require("dap").adapters.lldb.command = "${pkgs.vscode-extensions.vadimcn.vscode-lldb.adapter}/bin/codelldb"
          '';
      }

      {
        plugin = ps.nvim-dap-virtual-text;
        type = "lua";
        config = # lua
          ''
            require("nvim-dap-virtual-text").setup()
          '';
      }

      {
        plugin = ps.conjure;
        type = "lua";
        config = # lua
          ''
            vim.g["conjure#mapping#doc_word"] = false
            vim.g["conjure#mapping#def_word"] = false
          '';
      }

      {
        plugin = ps.vim-tmux-navigator;
        type = "lua";
        config = # lua
          ''
            vim.g.tmux_navigator_no_mappings = 1

            vim.api.nvim_set_keymap("n", "<C-h>", ":<C-U>TmuxNavigateLeft<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<C-j>", ":<C-U>TmuxNavigateDown<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<C-k>", ":<C-U>TmuxNavigateUp<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<C-l>", ":<C-U>TmuxNavigateRight<CR>", { noremap = true, silent = true })
          '';
      }

      ps.markdown-preview-nvim
      {
        plugin = ps.markview-nvim;
        type = "lua";
        config = builtins.readFile ./lua/plugin/markview.lua;
      }

      {
        plugin = ps.leap-nvim;
        type = "lua";
        config = # lua
          ''
            require('leap').create_default_mappings()
          '';
      }

      ps.nvim-notify

      {
        plugin = ps.noice-nvim;
        type = "lua";
        config = builtins.readFile ./lua/plugin/noice.lua;
      }

      {
        plugin = ps.rustaceanvim;
        type = "lua";
        config = # lua
          ''
            vim.g.rustaceanvim = {
              tools = {
                enable_clippy = true,
              },
              server = {
                default_settings = {
                  ['rust-analyzer'] = {
                  },
                },
              },
              dap = {
              },
            }
          '';
      }

      {
        plugin = ps.haskell-tools-nvim;
        type = "lua";
        config = # lua
          ''
            vim.g.haskell_tools = {
              hls = {
                settings = {
                  haskell = {
                    formattingProvider = "stylish-haskell",
                    plugin = {
                      rename = {
                        config = {
                          crossModule = true,
                        },
                      },
                    },
                  },
                },
              },
            }
          '';
      }

      ps.haskell-snippets-nvim
      ps.Coqtail
      ps.emmet-vim
      ps.nvim-web-devicons
      ps.vim-surround
      ps.diffview-nvim
    ];
}
