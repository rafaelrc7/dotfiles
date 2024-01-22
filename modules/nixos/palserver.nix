{ pkgs, config, ... }:
let palserver_path = "/var/lib/palworld";
    palserver_update = pkgs.writeShellScriptBin "palserver_update" ''
      ${pkgs.steamcmd}/bin/steamcmd +login anonymous +app_update 2394010 validate +quit
      [[ ! -a ~/.steam/sdk32 ]] && ln -s ~/.local/share/Steam/linux32 ~/.steam/sdk32
      [[ ! -a ~/.steam/sdk64 ]] && ln -s ~/.local/share/Steam/linux64 ~/.steam/sdk64
      true
    '';
in {
  users.users.palworld = {
    isSystemUser = true;
    home = palserver_path;
    createHome = true;
    group = "palworld";
    shell = "${pkgs.shadow}/bin/nologin";
    packages = with pkgs; [ steamcmd steam-run palserver_update ];
  };

  users.groups.palworld = {
    gid = config.users.users.palworld.uid;
  };

  # Main Server service
  systemd.services.palserver = {
    unitConfig = {
      Description = "PalWorld Server";
      Documentation = [ "https://tech.palworldgame.com/dedicated-server-guide" ];
    };

    serviceConfig = {
      User = "palworld";
      Group = "palworld";
      WorkingDirectory = "${palserver_path}/.local/share/Steam/Steamapps/common/PalServer";
      ExecStartPre = "${palserver_update}/bin/palserver_update";
      ExecStart = "${pkgs.steam-run}/bin/steam-run ./PalServer.sh EpicApp=PalServer -publicport=8211 -port=8211 -useperfthreads -NoAsyncLoadingThread -UseMultithreadForDs";
      Restart = "always";
      RestartSec = "15s";
    };

    #wantedBy = [ "multi-user.target" ];

  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
}

