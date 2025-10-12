{ pkgs, config, ... }:
let
  palserver_path = "/var/lib/palworld";
  palserver_update = pkgs.writeShellScriptBin "palserver_update" ''
    set -eo pipefail
    ${pkgs.steamcmd}/bin/steamcmd +login anonymous +app_update 2394010 validate +quit
    [[ ! -e ~/.steam/sdk32 ]] && ln -s ~/.local/share/Steam/linux32 ~/.steam/sdk32
    [[ ! -e ~/.steam/sdk64 ]] && ln -s ~/.local/share/Steam/linux64 ~/.steam/sdk64
    exit 0
  '';
  palserver_restart = pkgs.writeShellScriptBin "palserver_restart" ''
    set -eo pipefail
    ${pkgs.rconc}/bin/rconc localhost Save
    ${pkgs.rconc}/bin/rconc localhost Shutdown 30
    exit 0
  '';
  palserver_reminder = pkgs.writeShellScriptBin "palserver_reminder" ''
    set -eo pipefail
    ${pkgs.rconc}/bin/rconc localhost Broadcast Servidor_Reiniciara_5:00_17:00_automaticamente
    exit 0
  '';
in
{
  users.users.palworld = {
    isSystemUser = true;
    home = palserver_path;
    createHome = true;
    group = "palworld";
    shell = "${pkgs.shadow}/bin/nologin";
  };

  users.groups.palworld = {
    gid = config.users.users.palworld.uid;
  };

  systemd.services = {
    # Main server service
    palserver = {
      unitConfig = {
        Description = "PalWorld Server";
        Documentation = [ "https://tech.palworldgame.com/dedicated-server-guide" ];
      };

      serviceConfig = {
        User = "palworld";
        Group = "palworld";
        WorkingDirectory = "${palserver_path}/.local/share/Steam/Steamapps/common/PalServer";
        ExecStartPre = "${palserver_update}/bin/palserver_update";
        ExecStart = "${pkgs.steam-run}/bin/steam-run ./PalServer.sh -publicport=8211 -port=8211 -useperfthreads -NoAsyncLoadingThread -UseMultithreadForDs";
        Restart = "always";
        RestartSec = "15s";
      };

      #wantedBy = [ "multi-user.target" ];
    };

    # Restart server service
    palserver_restart = {
      unitConfig = {
        Description = "Restart PalWorld Server";
        Documentation = [ "https://tech.palworldgame.com/dedicated-server-guide" ];
      };

      serviceConfig = {
        User = "palworld";
        Group = "palworld";
        WorkingDirectory = "${palserver_path}/.local/share/Steam/Steamapps/common/PalServer";
        ExecStart = "${palserver_restart}/bin/palserver_restart";
      };
    };

    # Restart Reminder service
    palserver_reminder = {
      unitConfig = {
        Description = "Restart PalWorld Server Schedule Reminder";
        Documentation = [ "https://tech.palworldgame.com/dedicated-server-guide" ];
      };

      serviceConfig = {
        User = "palworld";
        Group = "palworld";
        WorkingDirectory = "${palserver_path}/.local/share/Steam/Steamapps/common/PalServer";
        ExecStart = "${palserver_reminder}/bin/palserver_reminder";
      };
    };
  };

  systemd.timers = {
    # Restart timer
    palserver_restart = {
      unitConfig = {
        Description = "Restart PalWorld Server";
        BindsTo = [ "palserver.service" ];
      };

      timerConfig = {
        OnCalendar = "*-*-* 05,17:00:00";
      };

      wantedBy = [ "palserver.service" ];
    };

    # Restart reminder timer
    palserver_reminder = {
      unitConfig = {
        Description = "Restart PalWorld Server";
        BindsTo = [ "palserver.service" ];
      };

      timerConfig = {
        OnCalendar = [
          "*-*-* 04,16:45,50,55:00"
          "*-*-* *:00,30:00"
        ];
      };

      wantedBy = [ "palserver.service" ];
    };
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
}
