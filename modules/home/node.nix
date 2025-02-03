{ config, pkgs, ... }:
let
  npm_user_global_path = "${config.xdg.dataHome}/npm-global";
in
{
  home.packages = with pkgs; [ nodejs ];
  home.file.".npmrc".text = ''
    prefix=${npm_user_global_path}
  '';
  home.sessionPath = [ "${npm_user_global_path}/bin" ];
}
