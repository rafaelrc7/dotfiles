{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
    authentication = lib.mkOverride 10 ''
      local all all               trust
      host  all all 127.0.0.1/32  trust
      host  all all ::1/128       trust
      host  all all 100.64.0.0/10 trust
    '';
    settings = {
      listen_addresses = lib.mkForce "*";
    };
  };

  networking.firewall.interfaces.${config.services.tailscale.interfaceName}.allowedTCPPorts = [
    5432
  ];
}
