{ self, ... }:
{ inputs, pkgs, ... }: {
  networking.hostName = "vulcan";

  systemd.services.nix-daemon.serviceConfig.AllowedCPUs = "2-15";

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
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
    libvirtd
    lutris
    mullvad
    nix
    pipewire
    steam
    zsh
    podman
    fonts
    cryptswap
    man
    ssh
    git
    polkit
    tailscale
    waydroid
    systemd-oomd

    temperature-symlink
  ]) ++ (with inputs; [
    nixos-hardware.nixosModules.common-pc
    nixos-hardware.nixosModules.common-pc-ssd
    nixos-hardware.nixosModules.common-gpu-amd
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-cpu-amd-pstate
  ]);

  environment = {
    systemPackages = with pkgs; [
      dbeaver-bin
      libva-utils
      glxinfo
      xclip
      wineWowPackages.staging
      winetricks
      qbittorrent
      vlc
    ];
  };

  programs.java.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        libvdpau-va-gl
        libva-vdpau-driver

        rocmPackages.clr
        rocmPackages.clr.icd
      ];
      extraPackages32 = with pkgs.driversi686Linux; [
        libvdpau-va-gl
        libva-vdpau-driver
      ];
    };
  };

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  services.postgresql = {
    enable = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all peer
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
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
      publish.enable = true;
      publish.addresses = true;
      publish.userServices = true;
    };
  };

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.epson-escpr ];
  };

  programs.dconf.enable = true;
  programs.mtr.enable = true;

  services.hwmonLinks = {
    enable = true;
    devices = [
      {
        name = "k10temp";
        target = "cpu";
        input = "temp1_input";
      }
      {
        name = "amdgpu";
        target = "gpu";
        input = "temp1_input";
      }
    ];
  };

  system.stateVersion = "22.11";
}

