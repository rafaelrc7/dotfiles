args@{
  pkgs,
  lib,
  config,
  ...
}:
let
  email-utils = import ./email-utils.nix args;
in
{
  imports = [
    ./neomutt.nix
  ];

  accounts.email.maildirBasePath = "${config.xdg.dataHome}/maildir";

  programs.msmtp.enable = true;
  programs.mbsync.enable = true;
  programs.notmuch.enable = true;
  services.imapnotify.enable = true;
  programs.abook = {
    enable = true;
    extraConfig = ''
      set www_command=${pkgs.lynx}/bin/lynx
      set print_command=${pkgs.cups}/bin/lpr
      set use_ascii_only=false
      set use_colors=true
      set mutt_command=${pkgs.neomutt}/bin/neomutt
    '';
  };

  # Runs mbsync once after login
  systemd.user = {
    services.mbsync-login = {
      Unit = {
        Description = "Sync emails on login";
        Wants = [ "network-online.target" ];
        After = [ "network-online.target" ];
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${lib.getExe email-utils.sync-mail}";
        ExecStartPost = "${lib.getExe email-utils.notify-new-mail}";
        Restart = "on-failure";
        RestartSec = "10s";
      };

      Install.WantedBy = [ "default.target" ];
    };
  };
}
