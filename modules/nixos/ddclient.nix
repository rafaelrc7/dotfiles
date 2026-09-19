{ ... }:
{
  services.ddclient = {
    enable = true;
    configFile = "/etc/ddclient.conf";
  };

  # https://github.com/NixOS/nixpkgs/issues/350408
  systemd.services.ddclient.after = [ "nss-user-lookup.target" ];
}
