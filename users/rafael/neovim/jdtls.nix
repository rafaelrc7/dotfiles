{ lib, pkgs, ... }:
{
  programs.neovim = {
    plugins =
      let
        ps = pkgs.vimPlugins;
      in
      [ ps.nvim-jdtls ];
    extraPackages = with pkgs; [
      jdt-language-server
      vscode-extensions.vscjava.vscode-java-debug
      vscode-extensions.vscjava.vscode-java-test
    ];
  };

  xdg.configFile."nvim/ftplugin/java.lua".source = pkgs.replaceVars ./lua/plugin/jdtls.lua {
    jdk = lib.getExe pkgs.jdk;
    jdtls = pkgs.jdt-language-server;
    lombok = pkgs.lombok;
    vscode-java-debug = pkgs.vscode-extensions.vscjava.vscode-java-debug;
    vscode-java-test = pkgs.vscode-extensions.vscjava.vscode-java-test;
  };
}
