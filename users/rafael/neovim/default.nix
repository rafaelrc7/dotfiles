{ lib, pkgs, ... }:
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

    extraLuaConfig =
      let
        inherit (import ./util.nix { inherit lib; }) insertChunks;
      in
      insertChunks [
        ./lua/options.lua
        ./lua/maps.lua
        ./lua/autocmds.lua
        ./lua/filetypes.lua
        ./lua/godot.lua
      ];

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
      graphviz
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
      lemminx
      lua-language-server
      nixd
      nixfmt
      nodePackages.bash-language-server
      pyright
      stylua
      texlab
      vscode-langservers-extracted

      # Haskell
      haskellPackages.fast-tags

      # debug
      gdb
      lldb
      vscode-extensions.vadimcn.vscode-lldb.adapter
    ];
  };
}
