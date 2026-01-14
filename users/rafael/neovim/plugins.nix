{ lib, pkgs, ... }:
let
  inherit (import ./util.nix { inherit lib; }) insertChunk insertPCall;
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
        config = insertChunk ./lua/plugin/firenvim.lua;
      }

      {
        plugin = ps.nvim-cmp;
        type = "lua";
        config = insertChunk ./lua/plugin/cmp.lua;
      }
      {
        plugin = ps.cmp-git;
        type = "lua";
        config =
          insertPCall "cmp-git" # lua
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

      ps.friendly-snippets
      {
        plugin = ps.luasnip;
        type = "lua";
        config =
          insertPCall "luasnip" # lua
            ''
              require("luasnip.loaders.from_vscode").lazy_load()
            '';
      }

      {
        plugin = ps.nvim-lspconfig;
        type = "lua";
        config = insertChunk ./lua/plugin/lsp.lua;
      }
      ps.actions-preview-nvim

      {
        plugin = ps.conform-nvim;
        type = "lua";
        config = insertChunk ./lua/plugin/conform.lua;
      }

      {
        plugin = ps.nvim-autopairs;
        type = "lua";
        config = insertChunk ./lua/plugin/nvim-autopairs.lua;
      }

      {
        plugin = ps.nvim-ts-autotag;
        type = "lua";
        config =
          insertPCall "nvim-ts-autotag" # lua
            ''
              require("nvim-ts-autotag").setup {}
            '';
      }

      {
        plugin = ps.telescope-nvim;
        type = "lua";
        config = insertChunk ./lua/plugin/telescope.lua;
      }
      ps.telescope-fzf-native-nvim
      ps.telescope-ui-select-nvim

      {
        plugin = ps.gitsigns-nvim;
        type = "lua";
        config = insertChunk ./lua/plugin/gitsigns.lua;
      }

      {
        plugin = ps.trouble-nvim;
        type = "lua";
        config = insertChunk ./lua/plugin/trouble.lua;
      }

      {
        plugin = ps.vimtex;
        type = "lua";
        config =
          insertPCall "vimtex" # lua
            ''
              vim.g.tex_flavor = "latex"
              vim.g.vimtex_view_method = "zathura"
            '';
      }

      {
        plugin = ps.oil-nvim;
        type = "lua";
        config = insertChunk ./lua/plugin/oil.lua;
      }

      {
        plugin = ps.nvim-highlight-colors;
        type = "lua";
        config =
          insertPCall "nvim-highlight-colors" # lua
            ''
              require("nvim-highlight-colors").setup {}
            '';
      }

      {
        plugin = ps.vim-fugitive;
        type = "lua";
        config =
          insertPCall "vim-fugitive" # lua
            ''
              vim.keymap.set("n", "<leader>gs",  ":G<CR>",           { silent = true, desc = "[G]it [s]tatus" })
              vim.keymap.set("n", "<leader>[gd", ":diffget //2<CR>", { silent = true, desc = "[G]it [d]iff left" })
              vim.keymap.set("n", "<leader>]gd", ":diffget //3<CR>", { silent = true, desc = "[G]it [d]iff right" })
            '';
      }

      {
        plugin = ps.nvim-navic;
        type = "lua";
        config =
          insertPCall "nvim-navic" # lua
            ''
              require("nvim-navic").setup {
              	highlight = true,
              	lsp = { auto_attach = true, },
              }
            '';
      }

      {
        plugin = ps.lualine-nvim;
        type = "lua";
        config = insertChunk ./lua/plugin/lualine.lua;
      }

      {
        plugin = ps.bufferline-nvim;
        type = "lua";
        config =
          insertPCall "bufferline" # lua
            ''
              require("bufferline").setup {}
            '';
      }

      {
        plugin = ps.vim-illuminate;
        type = "lua";
        config =
          insertPCall "illuminate" # lua
            ''
              require("illuminate").configure {
              	filetypes_denylist = { "dirbuf", "dirvish", "fugitive", "NvimTree", },
              }
            '';
      }

      {
        plugin = ps.toggleterm-nvim;
        type = "lua";
        config = insertChunk ./lua/plugin/toggleterm.lua;
      }

      {
        plugin = ps.nvim-dap-ui;
        type = "lua";
        config =
          insertPCall "dapui" # lua
            ''
              require("dapui").setup()
            '';
      }

      {
        plugin = ps.nvim-dap;
        type = "lua";
        config = (
          insertPCall "dap.lua" # lua
            ''
              ${builtins.readFile ./lua/plugin/dap.lua}
              require("dap").adapters.gdb.command = "${pkgs.gdb}/bin/gdb"
              require("dap").adapters.lldb.command = "${pkgs.vscode-extensions.vadimcn.vscode-lldb.adapter}/bin/codelldb"
            ''
        );
      }

      {
        plugin = ps.nvim-dap-virtual-text;
        type = "lua";
        config =
          insertPCall "nvim-dap-virtual-text" # lua
            ''
              require("nvim-dap-virtual-text").setup()
            '';
      }

      {
        plugin = ps.conjure;
        type = "lua";
        config =
          insertPCall "conjure" # lua
            ''
              vim.g["conjure#mapping#doc_word"] = false
              vim.g["conjure#mapping#def_word"] = false
            '';
      }

      {
        plugin = ps.vim-tmux-navigator;
        type = "lua";
        config =
          insertPCall "vim-tmux-navigator" # lua
            ''
              vim.g.tmux_navigator_no_mappings = 1

              vim.keymap.set("n", "<C-h>", ":<C-U>TmuxNavigateLeft<CR>", { noremap = true, silent = true })
              vim.keymap.set("n", "<C-j>", ":<C-U>TmuxNavigateDown<CR>", { noremap = true, silent = true })
              vim.keymap.set("n", "<C-k>", ":<C-U>TmuxNavigateUp<CR>", { noremap = true, silent = true })
              vim.keymap.set("n", "<C-l>", ":<C-U>TmuxNavigateRight<CR>", { noremap = true, silent = true })
            '';
      }

      ps.markdown-preview-nvim
      {
        plugin = ps.markview-nvim;
        type = "lua";
        config = insertChunk ./lua/plugin/markview.lua;
      }

      {
        plugin = ps.leap-nvim;
        type = "lua";
        config =
          insertPCall "leap-nvim" # lua
            ''
              vim.keymap.set({'n', 'x', 'o'}, 's',  '<Plug>(leap-forward)')
              vim.keymap.set({'n', 'x', 'o'}, 'S',  '<Plug>(leap-backward)')
              vim.keymap.set('n',             'gs', '<Plug>(leap-from-window)')
            '';
      }

      ps.nvim-notify

      {
        plugin = ps.noice-nvim;
        type = "lua";
        config = insertChunk ./lua/plugin/noice.lua;
      }

      {
        plugin = ps.rustaceanvim;
        type = "lua";
        config = insertChunk ./lua/plugin/rustaceanvim.lua;
      }

      {
        plugin = ps.haskell-tools-nvim;
        type = "lua";
        config = insertChunk ./lua/plugin/haskell-tools.lua;
      }

      ps.haskell-snippets-nvim
      ps.Coqtail
      ps.emmet-vim
      ps.nvim-web-devicons
      ps.vim-surround
      ps.diffview-nvim
    ];
}
