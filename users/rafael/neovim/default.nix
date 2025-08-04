{ pkgs, ... }:
{
  imports = [
    ./plugins.nix
    ./treesitter.nix
    ./jdtls.nix
  ];

  xdg.dataFile."nvim/site/spell" = {
    recursive = true;
    source = "${pkgs.vim-spell-dict}/share/spell";
  };

  xdg.configFile."nvim" = {
    recursive = true;
    source = ./lua/config;
  };

  programs.neovim = {
    enable = true;

    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withPython3 = true;
    withNodeJs = true;

    extraLuaConfig = ''

      ${builtins.readFile ./lua/options.lua}

      ${builtins.readFile ./lua/maps.lua}

      ${builtins.readFile ./lua/autocmds.lua}

      ${builtins.readFile ./lua/filetypes.lua}

      ${builtins.readFile ./lua/godot.lua}
    '';

    extraLuaPackages =
      lps: with lps; [
        luautf8
        jsregexp
      ];

    extraPackages = with pkgs; [
      clang
      curl
      delta
      fd
      ripgrep
      graphviz

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
      nodePackages.bash-language-server
      lua-language-server
      stylua
      nixd
      nixfmt-rfc-style
      pyright
      texlab
      vscode-langservers-extracted
      lemminx

      # Haskell
      haskellPackages.fast-tags

      # debug
      gdb
      lldb
      vscode-extensions.vadimcn.vscode-lldb.adapter
    ];
  };
}
