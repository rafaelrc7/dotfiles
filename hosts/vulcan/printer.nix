{ pkgs, ... }:
{
  services = {
    printing = {
      enable = true;
      drivers = [
        pkgs.epson-escpr
        pkgs.epson_201207w
      ];
      browsing = true;
      startWhenNeeded = true;
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      settings = {
        publish.disable-publishing = false;
        publish.publish-addresses = true;
        publish.disable-user-service-publishing = false;
      };
    };
  };

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.epson-escpr ];
  };
}
