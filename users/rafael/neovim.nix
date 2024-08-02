{ pkgs, ... }: {
  xdg.dataFile."nvim/site/spell" = {
    recursive = true;
    source = "${pkgs.vim-spell-dict}/share/spell";
  };

  xdg.configFile."nvim" = {
    recursive = true;
    source = ./nvimrc/nvim;
  };

  programs.neovim =
    let
      toLua = str: "lua << EOF\n${str}\nEOF\n";
      toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
    in
    {
      enable = true;

      defaultEditor = true;

      extraLuaPackages = lps: with lps; [ luautf8 jsregexp ];

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      withPython3 = true;
      withNodeJs = true;

      extraPackages = with pkgs; [
        clang
        fd
        ripgrep

        # Clipboard
        wl-clipboard
        xclip

        # Latex
        biber
        pstree
        texlive.combined.scheme-medium
        xdotool
        zathura

        # Commonly used LSPs
        clang-tools
        jdt-language-server
        lua-language-server
        nixd
        pyright
        texlab

        # Haskell
        haskellPackages.fast-tags

        # debug
        gdb
        haskellPackages.haskell-debug-adapter
      ];

      extraLuaConfig = ''

        ${builtins.readFile ./nvimrc/options.lua}

        ${builtins.readFile ./nvimrc/maps.lua}

        ${builtins.readFile ./nvimrc/autocmds.lua}
      '';

      plugins = let ps = pkgs.vimPlugins; in [
        # Dependencies from multiple plugins
        ps.plenary-nvim
        ps.nui-nvim
        ps.nvim-nio

        {
          plugin = ps.nvim-cmp;
          config = toLuaFile ./nvimrc/plugin/cmp.lua;
        }
        {
          plugin = ps.cmp-git;
          config = toLua ''require("cmp_git").setup()'';
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
          config = toLuaFile ./nvimrc/plugin/lsp.lua;
        }

        {
          plugin = ps.nvim-jdtls;
          config = toLuaFile ./nvimrc/plugin/nvim-jdtls.lua;
        }

        {
          plugin = ps.nvim-autopairs;
          config = toLuaFile ./nvimrc/plugin/nvim-autopairs.lua;
        }

        {
          plugin = ps.telescope-nvim;
          config = toLuaFile ./nvimrc/plugin/telescope.lua;
        }
        ps.telescope-fzf-native-nvim
        ps.telescope-ui-select-nvim

        {
          plugin = ps.actions-preview-nvim;
          config = toLua ''
            require("actions-preview").setup({
              require("actions-preview.highlight").delta("${pkgs.delta}/bin/delta --no-gitconfig --side-by-side"),
            })
            vim.keymap.set({ "v", "n" }, "<leader>ca", require("actions-preview").code_actions, { desc = "[C]ode [a]ctions" })
          '';
        }

        {
          plugin = ps.gitsigns-nvim;
          config = toLuaFile ./nvimrc/plugin/gitsigns.lua;
        }

        {
          plugin = ps.trouble-nvim;
          config = toLuaFile ./nvimrc/plugin/trouble.lua;
        }

        {
          plugin = ps.vimtex;
          config = toLuaFile ./nvimrc/plugin/vimtex.lua;
        }

        {
          plugin = ps.oil-nvim;
          config = toLua ''
            local oil = require("oil")
            oil.setup()
            vim.keymap.set("n", "-", oil.open, { desc = "Open parent directory" })
          '';
        }

        {
          plugin = ps.nvim-highlight-colors;
          config = toLua ''require("nvim-highlight-colors").setup({})'';
        }

        {
          plugin = ps.markdown-preview-nvim;
          config = toLua ''vim.api.nvim_set_keymap("n", "<S-m>", ":MarkdownPreview<CR>", { silent = true, noremap = true })'';
        }

        {
          plugin = ps.vim-fugitive;
          config = toLua ''
            vim.api.nvim_set_keymap("n", "<leader>gs", ":G<CR>", { silent = true, desc = "[G]it [s]tatus" }) -- git status
            vim.api.nvim_set_keymap("n", "<leader>gdh", ":diffget //2<CR>", { silent = true, desc = "[G]it [d]iff left ([h])" })
            vim.api.nvim_set_keymap("n", "<leader>gdl", ":diffget //3<CR>", { silent = true, desc = "[G]it [d]iff right ([l])" })
          '';
        }

        {
          plugin = ps.lsp-progress-nvim;
          config = toLua ''require("lsp-progress").setup()'';
        }

        {
          plugin = ps.nvim-navic;
          config = toLua ''
            require("nvim-navic").setup({
              highlight = true,
              lsp = { auto_attach = true, },
            })
          '';
        }

        {
          plugin = ps.lualine-nvim;
          config = toLuaFile ./nvimrc/plugin/lualine.lua;
        }

        {
          plugin = ps.nvim-navbuddy;
          config = toLua ''
            require("nvim-navbuddy").setup({
              lsp = { auto_attach = true, },
            })
            vim.keymap.set({ "v", "n" }, "<leader>nb", require("nvim-navbuddy").open, { desc = "[N]av [b]uddy" })
          '';
        }

        {
          plugin = ps.bufferline-nvim;
          config = toLua ''require("bufferline").setup({})'';
        }

        {
          plugin = ps.vim-illuminate;
          config = toLua ''
            require("illuminate").configure({
              filetypes_denylist = { "dirbuf", "dirvish", "fugitive", "NvimTree", },
            })
          '';
        }

        {
          plugin = ps.toggleterm-nvim;
          config = toLuaFile ./nvimrc/plugin/toggleterm.lua;
        }

        {
          plugin = ps.nvim-dap-ui;
          config = toLua ''require("dapui").setup()'';
        }

        {
          plugin = ps.nvim-dap;
          config = (toLuaFile ./nvimrc/plugin/dap.lua)
            + toLua ''require("dap").adapters.gdb.command = "${pkgs.gdb}/bin/gdb"'';
        }

        {
          plugin = ps.nvim-dap-virtual-text;
          config = toLua ''require("nvim-dap-virtual-text").setup()'';
        }

        {
          plugin = ps.conjure;
          config = toLua ''
            vim.g["conjure#mapping#doc_word"] = false
            vim.g["conjure#mapping#def_word"] = false
          '';
        }

        {
          plugin = ps.vim-tmux-navigator;
          config = toLua ''
            vim.g.tmux_navigator_no_mappings = 1

            vim.api.nvim_set_keymap("n", "<C-h>", ":<C-U>TmuxNavigateLeft<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<C-j>", ":<C-U>TmuxNavigateDown<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<C-k>", ":<C-U>TmuxNavigateUp<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<C-l>", ":<C-U>TmuxNavigateRight<CR>", { noremap = true, silent = true })
          '';
        }

        ps.haskell-tools-nvim
        ps.Coqtail
        ps.emmet-vim
        ps.nvim-web-devicons

        {
          config = toLuaFile ./nvimrc/plugin/treesitter.lua;
          plugin = (ps.nvim-treesitter.withPlugins (p: with p; [
            yaml
            xml
            vimdoc
            vim
            typescript
            toml
            ssh_config
            sql
            scss
            scheme
            rust
            rst
            regex
            racket
            r
            python
            perl
            passwd
            ocaml
            ocamllex
            ocaml_interface
            objdump
            nix
            ninja
            nasm
            meson
            matlab
            markdown_inline
            markdown
            make
            lua
            llvm
            latex
            kotlin
            julia
            json5
            json
            jq
            javascript
            java
            ini
            http
            html
            hlsl
            haskell
            groovy
            gpg
            godot_resource
            go
            glsl
            gitignore
            gitcommit
            gitattributes
            git_rebase
            git_config
            git_config
            gdscript
            fennel
            elixir
            dockerfile
            diff
            csv
            css
            cpp
            commonlisp
            comment
            cmake
            c_sharp
            c
            bibtex
            bash
            awk
            arduino
          ]));
        }
      ];

    };
}

