{ pkgs, ... }:
let
  toLua = str: "lua << EOF\n${str}\nEOF\n";
  toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
in
{
  programs.neovim.plugins = let ps = pkgs.vimPlugins; in [
    # Dependencies from multiple plugins
    ps.plenary-nvim
    ps.nui-nvim
    ps.nvim-nio

    ps.which-key-nvim

    {
      plugin = ps.nvim-cmp;
      config = toLuaFile ./lua/plugin/cmp.lua;
    }
    {
      plugin = ps.cmp-git;
      config = toLua /* lua */ ''
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
      config = toLuaFile ./lua/plugin/lsp.lua;
    }
    ps.actions-preview-nvim

    {
      plugin = ps.nvim-autopairs;
      config = toLuaFile ./lua/plugin/nvim-autopairs.lua;
    }

    {
      plugin = ps.telescope-nvim;
      config = toLuaFile ./lua/plugin/telescope.lua;
    }
    ps.telescope-fzf-native-nvim
    ps.telescope-ui-select-nvim

    {
      plugin = ps.gitsigns-nvim;
      config = toLuaFile ./lua/plugin/gitsigns.lua;
    }

    {
      plugin = ps.trouble-nvim;
      config = toLuaFile ./lua/plugin/trouble.lua;
    }

    {
      plugin = ps.vimtex;
      config = toLua /* lua */ ''
        vim.g.tex_flavor = "latex"
        vim.g.vimtex_view_method = "${pkgs.zathura}/bin/zathura"
      '';
    }

    {
      plugin = ps.oil-nvim;
      config = toLua /* lua */ ''
        local oil = require("oil")
        oil.setup()
        vim.keymap.set("n", "-", oil.open, { desc = "Open parent directory" })
      '';
    }

    {
      plugin = ps.nvim-highlight-colors;
      config = toLua /* lua */ ''
        require("nvim-highlight-colors").setup({})
      '';
    }

    {
      plugin = ps.markdown-preview-nvim;
      config = toLua /* lua */ ''
        vim.api.nvim_set_keymap("n", "<S-m>", ":MarkdownPreview<CR>", { silent = true, noremap = true })
      '';
    }

    {
      plugin = ps.vim-fugitive;
      config = toLua /* lua */ ''
        vim.api.nvim_set_keymap("n", "<leader>gs", ":G<CR>", { silent = true, desc = "[G]it [s]tatus" }) -- git status
        vim.api.nvim_set_keymap("n", "<leader>gdh", ":diffget //2<CR>", { silent = true, desc = "[G]it [d]iff left ([h])" })
        vim.api.nvim_set_keymap("n", "<leader>gdl", ":diffget //3<CR>", { silent = true, desc = "[G]it [d]iff right ([l])" })
      '';
    }

    {
      plugin = ps.lsp-progress-nvim;
      config = toLua /* lua */ ''
        require("lsp-progress").setup()
      '';
    }

    {
      plugin = ps.nvim-navic;
      config = toLua /* lua */ ''
        require("nvim-navic").setup({
          highlight = true,
          lsp = { auto_attach = true, },
        })
      '';
    }

    {
      plugin = ps.lualine-nvim;
      config = toLuaFile ./lua/plugin/lualine.lua;
    }

    {
      plugin = ps.nvim-navbuddy;
      config = toLua /* lua */ ''
        require("nvim-navbuddy").setup({
          lsp = { auto_attach = true, },
        })
        vim.keymap.set({ "v", "n" }, "<leader>nb", require("nvim-navbuddy").open, { desc = "[N]av [b]uddy" })
      '';
    }

    {
      plugin = ps.bufferline-nvim;
      config = toLua /* lua */ ''
        require("bufferline").setup({})
      '';
    }

    {
      plugin = ps.vim-illuminate;
      config = toLua /* lua */ ''
        require("illuminate").configure({
          filetypes_denylist = { "dirbuf", "dirvish", "fugitive", "NvimTree", },
        })
      '';
    }

    {
      plugin = ps.toggleterm-nvim;
      config = toLuaFile ./lua/plugin/toggleterm.lua;
    }

    {
      plugin = ps.nvim-dap-ui;
      config = toLua /* lua */ ''
        require("dapui").setup()
      '';
    }

    {
      plugin = ps.nvim-dap;
      config = (toLuaFile ./lua/plugin/dap.lua)
        + toLua /* lua */ ''
        require("dap").adapters.gdb.command = "${pkgs.gdb}/bin/gdb"
      '';
    }

    {
      plugin = ps.nvim-dap-virtual-text;
      config = toLua /* lua */ ''
        require("nvim-dap-virtual-text").setup()
      '';
    }

    {
      plugin = ps.conjure;
      config = toLua /* lua */ ''
        vim.g["conjure#mapping#doc_word"] = false
        vim.g["conjure#mapping#def_word"] = false
      '';
    }

    {
      plugin = ps.vim-tmux-navigator;
      config = toLua /* lua */ ''
        vim.g.tmux_navigator_no_mappings = 1

        vim.api.nvim_set_keymap("n", "<C-h>", ":<C-U>TmuxNavigateLeft<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("n", "<C-j>", ":<C-U>TmuxNavigateDown<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("n", "<C-k>", ":<C-U>TmuxNavigateUp<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("n", "<C-l>", ":<C-U>TmuxNavigateRight<CR>", { noremap = true, silent = true })
      '';
    }

    ps.haskell-tools-nvim
    ps.haskell-snippets-nvim
    ps.Coqtail
    ps.emmet-vim
    ps.nvim-web-devicons
  ];
}

