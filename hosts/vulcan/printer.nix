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
      publish.enable = true;
      publish.addresses = true;
      publish.userServices = true;
    };
  };

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.epson-escpr ];
  };
}
