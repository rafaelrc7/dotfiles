{ pkgs, ... }:
{
  hardware.rtl-sdr.enable = true;

  environment.systemPackages = with pkgs; [
    libusb1
    rtl-sdr

    sdrpp
  ];

  networking.firewall.allowedTCPPorts = [ 5259 ];
}
