{
  lib,
  pkgs,
  config,
  ...
}:
let
  server_path = "/srv/blackmesaserver";

  server_update = pkgs.writeShellApplication {
    name = "server_update";
    runtimeInputs = with pkgs; [
      steamcmd
    ];
    text = ''
      set -eo pipefail

      # Install/Update Black Mesa Dedicated Server
      steamcmd +force_install_dir "${server_path}" +login anonymous +app_update 346680 +quit

      ## OPTIONAL: Remove textures to save ~9 GB.
      ## On the server, materials are needed but textures are not.
      ## If the server ever needs to be updated, these files will be redownloaded again.
      rm "${server_path}"/bms/bms_textures*
      rm "${server_path}"/hl2/hl2_textures*

      exit 0
    '';
  };

  server_install = pkgs.writeShellApplication {
    name = "server_install";
    runtimeInputs = with pkgs; [
      gnugrep
      gnused
      gnutar
      gzip
      steamcmd
      unzip
      wget
    ];
    text = ''
      set -eo pipefail

      steamcmd +force_install_dir "${server_path}" +login anonymous +app_update 346680 validate +quit

      ## OPTIONAL: Remove textures to save ~9 GB.
      ## On the server, materials are needed but textures are not.
      ## If the server ever needs to be updated, these files will be redownloaded again.
      rm "${server_path}"/bms/bms_textures*
      rm "${server_path}"/hl2/hl2_textures*

      # Install the latest version of Metamod
      wget "$(wget -qO- "https://www.sourcemm.net/downloads.php" | grep "<a class='quick-download download-link'" | grep -m1 "linux.tar.gz" | sed -n 's/.*href='\'''//; s/'\'''.*//p')" -O ".tmp.tar.gz"
      tar -xf ".tmp.tar.gz" -C "${server_path}/bms"
      rm ".tmp.tar.gz"

      # Install SourceMod version 7163.
      # The newer SourceMod versions have a regression within their detour hooking utilities.
      wget "https://sm.alliedmods.net/smdrop/1.12/sourcemod-1.12.0-git7163-linux.tar.gz" -O ".tmp.tar.gz"
      tar -xf ".tmp.tar.gz" -C "${server_path}/bms"
      rm ".tmp.tar.gz"

      # Install the latest version of Accelerator.
      wget "https://builds.limetech.io/$(wget -qO- "https://builds.limetech.io/?p=accelerator" | grep -m1 "linux.zip" | cut -d '"' -f2)" -O ".tmp.zip"
      unzip -o ".tmp.zip" -d "${server_path}/bms"
      rm ".tmp.zip"

      # Install the latest release of SourceCoop.
      wget "$(wget -qO- "https://api.github.com/repos/ampreeT/SourceCoop/releases/latest" | grep "browser_download_url" | grep -m1 "bms.zip" | cut -d '"' -f 4)" -O ".tmp.zip"
      unzip -o ".tmp.zip" -d "${server_path}/bms"
      rm ".tmp.zip"

      [[ ! -a ~/.steam/sdk32 ]] && ln -s ~/.local/share/Steam/linux32 ~/.steam/sdk32
      [[ ! -a ~/.steam/sdk64 ]] && ln -s ~/.local/share/Steam/linux64 ~/.steam/sdk64

      # Create default `mapcycle.txt`
      map_cycle_txt=$(cat << EOF
      bm_c0a0a
      bm_c1a0a
      bm_c1a1a
      bm_c1a2a
      bm_c1a3a
      bm_c1a4a
      bm_c2a1a
      bm_c2a1a
      bm_c2a2a
      bm_c2a3a
      bm_c2a4a
      bm_c2a4e
      bm_c2a5a
      bm_c3a1a
      bm_c3a2a
      bm_c4a1a
      bm_c4a2a
      bm_c4a3a
      EOF
      )
      echo "$map_cycle_txt" > "${server_path}/bms/mapcycle.txt"

      # Create default `server.cfg`
      server_cfg=$(cat << EOF
      // SourceCoop settings.
      mp_fraglimit 0      // Prevents the match from ending when a player has a high enough score.
      mp_teamplay 1       // Enables the scientist team.
      mp_friendlyfire 0   // Disables friendly fire.
      mp_forcerespawn 1   // Forces the player to respawn.

      // Add your settings below.
      hostname "Black Mesa: Cooperative"  // The name of the server.
      sv_password ""                      // Sets a server password for locking the server.
      rcon_password ""                    // Sets a RCON password for accessing adminstrative features. This is not recommended and SourceMod should be used instead.
      EOF
      )
      echo "$server_cfg" > "${server_path}/bms/cfg/server.cfg"

      # Empty the default `autoexec.cfg` as it does nothing for the server.
      : > "${server_path}/bms/cfg/autoexec.cfg"

      # Create an empty `userconfig.cfg` to suppress console warnings.
      : > "${server_path}/bms/cfg/userconfig.cfg"

      exit 0
    '';
  };

  server_run = pkgs.writeShellApplication {
    name = "server_run";
    runtimeInputs = with pkgs; [
      steam-run
    ];
    text = ''
      set -eo pipefail

      steam-run ./srcds_run -console -game bms -ip 0.0.0.0 +maxplayers 32 +mp_teamplay 1 +map bm_c0a0a

      exit 0
    '';
  };
in
{
  users.users.blackmesa = {
    isSystemUser = true;
    home = server_path;
    createHome = true;
    group = "blackmesa";
    shell = "${pkgs.shadow}/bin/nologin";
  };

  users.groups.blackmesa = {
    gid = config.users.users.blackmesa.uid;
  };

  systemd.services = {
    blackmesa-coop = {
      unitConfig = {
        Description = "BlackMesa Coop Server";
      };

      serviceConfig = {
        User = "blackmesa";
        Group = "blackmesa";
        WorkingDirectory = server_path;
        ExecStart = lib.getExe server_run;
        Restart = "always";
        RestartSec = "15s";
      };

      #wantedBy = [ "multi-user.target" ];
    };

    blackmesa-coop-update = {
      unitConfig = {
        Description = "Update BlackMesa Coop Server";
      };

      serviceConfig = {
        User = "blackmesa";
        Group = "blackmesa";
        WorkingDirectory = server_path;
        ExecStart = lib.getExe server_update;
      };
    };

    blackmesa-coop-install = {
      unitConfig = {
        Description = "Install BlackMesa Coop Server";
      };

      serviceConfig = {
        User = "blackmesa";
        Group = "blackmesa";
        WorkingDirectory = server_path;
        ExecStart = lib.getExe server_install;
      };
    };

  };

  programs.steam = {
    enable = true;
    dedicatedServer.openFirewall = true;
  };

  networking.firewall.allowedTCPPorts = [
    27015
  ];
  networking.firewall.allowedUDPPorts = [
    27015
  ];
}
