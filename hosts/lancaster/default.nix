{ self, ... }: with self.nixosModules;
{ config, inputs, pkgs, nixpkgs, home-manager, ... }: {
  networking.hostName = "lancaster";

  boot.kernel.sysctl."kernel.sysrq" = 1;

  imports = with inputs; [
    ./hardware-configuration.nix
    ./networking.nix

    common
    boot
    btrfs
    geoclue
    libvirtd
    mullvad
    nix
    pipewire
    zsh
    podman
    fonts
    cryptswap
    man
    ssh
    git
    polkit
    tailscale

    nixos-hardware.nixosModules.common-pc
    nixos-hardware.nixosModules.common-pc-ssd
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-cpu-amd-pstate
  ];

  services.xserver = {
    layout = "us";
    xkbVariant = "intl";
  };

  system.stateVersion = "22.11";
}

