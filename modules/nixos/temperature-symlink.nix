{ pkgs, lib, config, ... }:
let
  link_dir = "/var/run/hwmon_temps";
  linkTemp = pkgs.writeShellScriptBin "linkTemp" ''
    set -eo pipefail

    hwmon_name="''${1:?Missing hwmon name}"
    hwmon_target="''${2:?Missing target name}"
    hwmon_input="''${3:-temp1_input}"

    hwmon_dir="$(dirname $(grep -l $hwmon_name /sys/class/hwmon/hwmon*/name))"

    mkdir -p ${link_dir}
    ln -sf $hwmon_dir/$hwmon_input ${link_dir}/$hwmon_target

    exit 0
  '';

  cfg = config.services.hwmonLinks;

in
{

  options.services.hwmonLinks = with lib; {
    enable = mkEnableOption "hwmonLinks service";
    devices = mkOption {
      type = types.listOf (types.attrsOf (types.str));
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.hwmon_links =
      let
        linkTemps = pkgs.writeShellScriptBin "linkTemps" ''
          ${builtins.foldl' (acc: elem: acc + "${linkTemp}/bin/linkTemp ${elem.name} ${elem.target} ${elem.input}\n") "" cfg.devices}
        '';

        clearTemps = pkgs.writeShellScriptBin "clearTemps" ''
          ${builtins.foldl' (acc: elem: acc + "rm ${link_dir}/${elem.target}\n") "" cfg.devices}
          rmdir ${link_dir}
        '';
      in
      {
        wantedBy = [ "multi-user.target" ];
        script = "${linkTemps}/bin/linkTemps";
        postStop = "${clearTemps}/bin/clearTemps";
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = "yes";
        };
      };
  };

}

