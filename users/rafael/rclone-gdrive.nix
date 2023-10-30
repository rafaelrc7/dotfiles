{ config, pkgs, ... }:
let
  mount_directory = "${config.home.homeDirectory}/Documents/drive";
in {
  systemd.user.services = {
    rclone-gdrive = {
      Unit = {
        Description = "Automount google drive folder using rclone";
        AssertPathIsDirectory = mount_directory;
        Wants = "network-online.target";
        After = "network-online.target";
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.rclone}/bin/rclone mount --vfs-cache-mode full drive:Documents/ ${mount_directory}";
        ExecStop = "${pkgs.fuse}/bin/fusermount -zu ${mount_directory}";
        Restart = "on-failure";
        RestartSec = 30;
      };

      Install = {
        WantedBy = [ "multi-user.target" ];
      };
    };
  };
}

