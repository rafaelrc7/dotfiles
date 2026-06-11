{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.hyprsunset = {
    enable = true;
    settings = {
      profile = [
        {
          time = "6:30";
          identity = true;
        }
        {
          time = "19:00";
          temperature = 4000;
        }
      ];
    };
  };

  systemd.user.services.hyprsunset = rec {
    Service.Slice = "background-graphical.slice";
    Unit.After = Install.WantedBy;
    Install.WantedBy = lib.mkForce [ config.wayland.systemd.target ];
  };

  systemd.user.services.hyprsunset-hyprland-event-listener = rec {
    Install.WantedBy = [ "hyprsunset.service" ];

    Unit = {
      Description = "Listen to Hyprland events for toggling hyprsunset on hyprland events";
      After = Install.WantedBy;
    };

    Service = {
      Type = "exec";
      Restart = "always";
      ExecStart = lib.getExe (
        pkgs.writeShellApplication {
          name = "hyprsunset-hyprland-event-listener";
          runtimeInputs = with pkgs; [
            config.wayland.windowManager.hyprland.package
            jq
            socat
            systemd
          ];
          text = builtins.readFile ./hyprsunset-hyprland-event-listener.sh;
        }
      );
    };
  };

}
