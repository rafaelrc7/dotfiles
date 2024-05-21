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
        ps.plenary-nvim

        {
          plugin = ps.nvim-cmp;
          config = toLuaFile ./nvimrc/plugin/cmp.lua;
        }
        ps.cmp-buffer
        ps.cmp-cmdline
        ps.cmp-conjure
        ps.cmp_luasnip
        ps.cmp-nvim-lsp
        ps.cmp-path
        ps.cmp-rg
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

        {
          plugin = ps.gitsigns-nvim;
          config = toLua ''require("gitsigns").setup()'';
        }

        {
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
          config = toLuaFile ./nvimrc/plugin/treesitter.lua;
        }

        {
          plugin = ps.vimtex;
          config = toLuaFile ./nvimrc/plugin/vimtex.lua;
        }

        {
          plugin = ps.nvim-highlight-colors;
          config = toLua ''require("nvim-highlight-colors").setup({})'';
        }

        ps.markdown-preview-nvim
        ps.Coqtail
        ps.conjure
        ps.emmet-vim
        ps.symbols-outline-nvim
        ps.nvim-web-devicons
        ps.vimspector
        ps.undotree
        ps.tagbar
        ps.vim-fugitive
      ];

    };
}

