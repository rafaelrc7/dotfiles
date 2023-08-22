{ config, pkgs, ... }: let
  thunderbird-protonmail = pkgs.writeScriptBin "thunderbird" ''
    PROTONMAIL=`pgrep -u ${config.home.username} -f "protonmail-bridge"`
    [ x"$PROTONMAIL" == "x" ] && ${pkgs.protonmail-bridge}/bin/protonmail-bridge --noninteractive &
    exec ${pkgs.thunderbird}/bin/thunderbird
  '';
  thunderbird = pkgs.symlinkJoin {
    name = "thunderbird";
    paths = [
      thunderbird-protonmail pkgs.thunderbird
    ];
  };
in {
  home.packages = [ thunderbird ];
}

