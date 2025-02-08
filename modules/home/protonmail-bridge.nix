{ config, pkgs, ... }:
let
  getCert = pkgs.writeShellScriptBin "getCert" ''
    set -eo pipefail

    nc -z -v 127.000.001 1143
    echo\
      | ${pkgs.openssl}/bin/openssl s_client -starttls imap -connect 127.0.0.1:1143 2>/dev/null\
      | ${pkgs.openssl}/bin/openssl x509\
      > ${config.xdg.dataHome}/certs/protonmail.pem
  '';
in
{
  # Protonmail-Bridge service
  systemd.user.services.protonmail-bridge = {
    Unit = {
      Description = "Protonmail SMTP/IMAP client";
      Wants = "network-online.target";
      After = "network-online.target";
    };

    Service = {
      Type = "simple";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
      ExecStart = "${pkgs.protonmail-bridge}/bin/protonmail-bridge --noninteractive";
      Restart = "always";
    };

    Install.WantedBy = [ "default.target" ];
  };

  systemd.user.services.protonmail-bridge-cert = {
    Unit = {
      Description = "Protonmail SMTP/IMAP client certificate";
      Wants = "protonmail-bridge.service";
      After = "protonmail-bridge.service";
      StartLimitIntervalSec = "infinity";
      StartLimitBurst = 3;
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${getCert}/bin/getCert";
      Restart = "on-failure";
      RestartSec = 15;
    };

    Install.WantedBy = [ "default.target" ];
  };

  home.packages = [
    pkgs.protonmail-bridge
  ];

  xdg.configFile."protonmail/bridge-v3/keychain.json".text = ''
    {
      "Helper": "secret-service-dbus"
    }
  '';
}
