{ ... }:
{
  services.ddclient = {
    enable = true;
    configFile = "/etc/ddclient.conf";
  };
}
