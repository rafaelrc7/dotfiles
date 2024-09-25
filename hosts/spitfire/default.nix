{ self, ... }:
{ inputs, pkgs, ... }: {
  networking.hostName = "spitfire";

  boot.kernel.sysctl."kernel.sysrq" = 1;

  imports = (with self.nixosModules; [
    ./hardware-configuration.nix
    ./networking.nix

    common
    android
    boot
    btrfs
    flatpak
    geoclue
    gnupg-agent
    heroic
    lutris
    nix
    pipewire
    podman
    zsh
    fonts
    cryptswap
    man
    mullvad
    ssh
    git
    polkit
    powertop
    tailscale
    tlp
    udev-media-keys
    systemd-oomd

    temperature-symlink
  ]) ++ (with inputs; [
    nixos-hardware.nixosModules.common-cpu-intel
    "${nixos-hardware}/common/gpu/intel/tiger-lake"
    nixos-hardware.nixosModules.common-pc-laptop
    nixos-hardware.nixosModules.common-pc-laptop-ssd
  ]);

  environment = {
    systemPackages = with pkgs; [
      brightnessctl
      libva-utils
      glxinfo
      wineWowPackages.staging
      winetricks
      xclip
      qbittorrent
      vlc
    ];
  };

  programs.java.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services = {
    printing = {
      enable = true;
      drivers = [ pkgs.epson-escpr pkgs.epson_201207w ];
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

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan pkgs.epkowa ];
    disabledDefaultBackends = [ "v4l" "epson2" ];
  };
  services.ipp-usb.enable = true;

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

  programs.dconf.enable = true;
  programs.mtr.enable = true;

  systemd.services.brightness = {
    enable = true;
    script = ''
      ${pkgs.brightnessctl}/bin/brightnessctl set 30%
    '';
    wantedBy = [ "multi-user.target" ];
  };

  services.hwmonLinks = {
    enable = true;
    devices = [
      {
        name = "coretemp";
        target = "cpu";
        input = "temp1_input";
      }
    ];
  };

  system.stateVersion = "22.11";
}

