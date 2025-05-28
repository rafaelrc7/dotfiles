{
  config,
  pkgs,
  lib,
  ...
}:
let
  # Based on https://github.com/nix-community/home-manager/blob/master/modules/services/hyprsunset.nix
  hyprsunset-transitions = {
    sunrise = {
      calendar = "*-*-* 06:30:00";
      requests = [
        [ "disable" ]
        [
          "temperature"
          "6500"
        ]
      ];
    };
    sunset = {
      calendar = "*-*-* 18:00:00";
      requests = [
        [
          "temperature"
          "4000"
        ]
        [ "enable" ]
      ];
    };
  };
in
{
  systemd.user = {
    services =
      {
        hyprsunset-manager = rec {
          Install.WantedBy = [ "hyprsunset.service" ];

          Unit = {
            Description = "Manage Hyprsunset";
            Requires = "hyprsunset-manager.socket";
            Wants = Install.WantedBy;
            After = Install.WantedBy ++ [ "hyprsunset-manager.socket" ];
          };

          Service = {
            Type = "exec";
            Restart = "always";
            Sockets = "hyprsunset-manager.socket";
            StandardInput = "socket";
            StandardOutput = "journal";
            StandardError = "journal";
            ExecStart = lib.getExe (
              pkgs.writeShellApplication {
                name = "hyprsunset-manager";
                runtimeInputs = with pkgs; [
                  bc
                  config.wayland.windowManager.hyprland.package
                  dateutils
                  jq
                ];
                text = builtins.readFile ./hyprsunset-manager.sh;
              }
            );
          };
        };

        hyprsunset-manager-hyprland-event-listener = rec {
          Install.WantedBy = [ "hyprsunset-manager.service" ];

          Unit = {
            Description = "Listen to Hyprland events for hyprsunset manager";
            Requires = Install.WantedBy;
            Wants = Install.WantedBy;
            After = Install.WantedBy;
          };

          Service = {
            Type = "exec";
            Restart = "always";
            ExecStart = lib.getExe (
              pkgs.writeShellApplication {
                name = "hyprsunset-manager";
                runtimeInputs = with pkgs; [
                  config.wayland.windowManager.hyprland.package
                  jq
                  socat
                ];
                text = builtins.readFile ./hyprsunset-manager-hyprland-event-listener.sh;
              }
            );
          };
        };
      }
      // lib.mapAttrs' (
        name: transitionCfg:
        lib.nameValuePair "hyprsunset-transition-${name}" {
          Install = { };

          Unit = {
            ConditionEnvironment = "WAYLAND_DISPLAY";
            Description = "hyprsunset transition for ${name}";
            After = [ "hyprsunset-manager.service" ];
            Requires = [ "hyprsunset-manager.service" ];
          };

          Service = {
            Type = "oneshot";
            # Execute multiple requests sequentially
            ExecStart = pkgs.writeShellScript "hyprsunset-transition-${name}" (
              lib.concatMapStringsSep " && " (
                cmd: ''echo "${lib.escapeShellArgs cmd}" > "/run/user/$UID/hyprsunset-manager"''
              ) transitionCfg.requests
            );

          };
        }
      ) hyprsunset-transitions;

    timers = lib.mapAttrs' (
      name: transitionCfg:
      lib.nameValuePair "hyprsunset-transition-${name}" {
        Install = {
          WantedBy = [ config.wayland.systemd.target ];
        };

        Unit = {
          Description = "Timer for hyprsunset transition (${name})";
        };

        Timer = {
          OnCalendar = transitionCfg.calendar;
          Persistent = true;
        };
      }
    ) hyprsunset-transitions;

    sockets.hyprsunset-manager = {
      Unit = {
        BindsTo = "hyprsunset-manager.service";
      };

      Socket = {
        Service = "hyprsunset-manager.service";
        ListenFIFO = "%t/hyprsunset-manager";
        SocketMode = "0660";
        RemoveOnStop = true;
        FlushPending = true;
      };
    };
  };

  services.hyprsunset = {
    enable = true;
    extraArgs = [ "--identity" ];
  };

}
