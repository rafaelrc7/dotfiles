{ config, ... }:
let
  goPath = "${config.xdg.dataHome}/go";
in
{
  programs.go = {
    enable = true;
    env = {
      GOPATH = [ goPath ];
    };
  };

  home.sessionPath = [ "${goPath}/bin" ];
}
