{ pkgs, ... }:
{
  services = {
    ipp-usb.enable = true;

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
      publish.enable = true;
      publish.addresses = true;
      publish.userServices = true;
    };
  };

  hardware.printers = {
    ensureDefaultPrinter = "L355-Series";
    ensurePrinters = [
      {
        name = "L355-Series";
        location = "office";
        deviceUri = "usb://EPSON/L355%20Series?serial=53335A4B3039313191&interface=1";
        model = "epson-inkjet-printer-201207w/ppds/EPSON_L355.ppd";
        ppdOptions = {
          MediaType = "PLAIN";
          PrintQuality = "High";
          PageSize = "A4";
          OutputPaper = "A4";
          Color = "Grayscale";
        };
      }
    ];
  };

  hardware.sane = {
    enable = true;
    extraBackends = [
      pkgs.sane-airscan
      pkgs.epkowa
    ];
    disabledDefaultBackends = [
      "v4l"
      "epson2"
    ];
  };
}
