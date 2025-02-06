{ lib, ... }:
{
  services.postgresql = {
    enable = true;
    authentication = lib.mkOverride 10 ''
      local all all peer
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
  };
}
