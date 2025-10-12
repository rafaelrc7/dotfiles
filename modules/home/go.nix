{ config, ... }:
{
  programs.go = {
    enable = true;
    env = {
      GOPATH = [
        "${config.xdg.dataHome}/go"
      ];
    };
  };

  home.sessionPath = [ "$HOME/${config.programs.go.goPath}/bin" ];
}
