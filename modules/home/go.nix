{ config, ... }:
{
  programs.go = {
    enable = true;
    goPath = ".local/share/go";
  };

  home.sessionPath = [ "$HOME/${config.programs.go.goPath}/bin" ];
}
