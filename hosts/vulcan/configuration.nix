{
  pkgs,
  nixos-hardware,
  nixosModules,
  nixosProfiles,
  ...
}:
{
  networking.hostName = "vulcan";
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  boot.initrd.systemd.enable = true;

  imports = [
    ./gpu.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./printer.nix
  ]
  ++ (with nixosProfiles; [
    base
    pc
    gaming
  ])
  ++ (with nixosModules; [
    cryptswap
    systemd-boot
    zram

    guix
    java
    libvirtd
    llm
    mullvad
    podman
    postgresql
    rtl-sdr
    waydroid
  ])
  ++ (with nixos-hardware.nixosModules; [
    common-cpu-amd
    common-cpu-amd-pstate
    common-gpu-nvidia
    common-pc
    common-pc-ssd
  ]);

  services.hwmonLinks = {
    enable = true;
    devices = [
      {
        name = "k10temp";
        target = "cpu";
        input = "temp1_input";
      }
    ];
  };

  systemd.services.nix-daemon.serviceConfig.AllowedCPUs = "2-15";

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  system.stateVersion = "22.11";
}
