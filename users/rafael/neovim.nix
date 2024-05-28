{ pkgs, ... }: {
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
      ];

      extraLuaConfig = ''

        ${builtins.readFile ./nvimrc/options.lua}

        ${builtins.readFile ./nvimrc/maps.lua}

        ${builtins.readFile ./nvimrc/autocmds.lua}
      '';

      plugins = let ps = pkgs.vimPlugins; in [
        ps.plenary-nvim # Dependency from multiple plugins

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
          plugin = ps.lualine-nvim;
          config = toLuaFile ./nvimrc/plugin/lualine.lua;
        }
        ps.lualine-lsp-progress

        {
          plugin = ps.nvim-autopairs;
          config = toLuaFile ./nvimrc/plugin/nvim-autopairs.lua;
        }

        {
          plugin = ps.nvim-tree-lua;
          config = toLuaFile ./nvimrc/plugin/nvim-tree.lua;
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
            vim.keymap.set({ "v", "n" }, "<leader>ca", require("actions-preview").code_actions)
          '';
        }

        {
          plugin = ps.gitsigns-nvim;
          config = toLua ''require("gitsigns").setup()'';
        }

        {
          plugin = ps.trouble-nvim;
          config = toLuaFile ./nvimrc/plugin/trouble.lua;
        }

        {
          plugin = ps.symbols-outline-nvim;
          config = toLua ''
            require("symbols-outline").setup()
            vim.keymap.set({ "v", "n" }, "<leader>ts", ":SymbolsOutline<CR>", { silent = true })
          '';
        }

        {
          plugin = ps.vimtex;
          config = toLuaFile ./nvimrc/plugin/vimtex.lua;
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
            vim.api.nvim_set_keymap("n", "<leader>gs", ":G<CR>", {}) -- git status
            vim.api.nvim_set_keymap("n", "<leader>gdh", ":diffget //2<CR>", {})
            vim.api.nvim_set_keymap("n", "<leader>gdl", ":diffget //3<CR>", {})
          '';
        }

        ps.Coqtail
        ps.conjure
        ps.emmet-vim
        ps.nvim-web-devicons
        ps.vimspector

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

