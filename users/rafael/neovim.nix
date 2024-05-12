{ pkgs, ... }: {
  xdg.configFile."nvim/lua" = {
    source = ./nvimrc/lua;
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
      ];

      extraLuaConfig = ''

        ${builtins.readFile ./nvimrc/options.lua}

        ${builtins.readFile ./nvimrc/maps.lua}

        ${builtins.readFile ./nvimrc/autocmds.lua}
      '';

      plugins = with pkgs.vimPlugins; [
        {
          plugin = gruvbox-nvim;
          config = toLuaFile ./nvimrc/plugin/gruvbox.lua;
        }

        {
          plugin = nvim-cmp;
          config = toLuaFile ./nvimrc/plugin/cmp.lua;
        }
        cmp-buffer
        cmp-cmdline
        cmp-conjure
        cmp_luasnip
        cmp-nvim-lsp
        cmp-path
        cmp-rg
        cmp-treesitter

        luasnip

        {
          plugin = nvim-lspconfig;
          config = toLuaFile ./nvimrc/plugin/lsp.lua;
        }

        {
          plugin = nvim-jdtls;
          config = toLuaFile ./nvimrc/plugin/nvim-jdtls.lua;
        }

        {
          plugin = lualine-nvim;
          config = toLuaFile ./nvimrc/plugin/lualine.lua;
        }
        lualine-lsp-progress

        {
          plugin = nvim-autopairs;
          config = toLuaFile ./nvimrc/plugin/nvim-autopairs.lua;
        }

        {
          plugin = nvim-tree-lua;
          config = toLuaFile ./nvimrc/plugin/nvim-tree.lua;
        }

        {
          plugin = telescope-nvim;
          config = toLuaFile ./nvimrc/plugin/telescope.lua;
        }
        telescope-fzy-native-nvim

        {
          plugin = gitsigns-nvim;
          config = toLua ''require("gitsigns").setup()'';
        }

        {
          plugin = (nvim-treesitter.withPlugins (p: with p; [
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
          plugin = vimtex;
          config = toLuaFile ./nvimrc/plugin/vimtex.lua;
        }

        plenary-nvim
        markdown-preview-nvim
        Coqtail
        conjure
        emmet-vim
        symbols-outline-nvim
        nvim-web-devicons
        vimspector
        undotree
        nerdcommenter
        tagbar
        vim-fugitive
      ];

    };
}

