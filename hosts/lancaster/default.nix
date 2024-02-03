{ self, ... }: with self.nixosModules;
{ config, inputs, pkgs, nixpkgs, home-manager, ... }: {
  networking.hostName = "lancaster";

  boot.kernel.sysctl."kernel.sysrq" = 1;

  imports = with inputs; [
    ./hardware-configuration.nix
    ./networking.nix

    common
    btrfs
    ddclient
    geoclue
    nix
    pipewire
    zsh
    podman
    fonts
    man
    ssh
    git
    polkit
    tailscale
    palserver

    nixos-hardware.nixosModules.common-pc
    nixos-hardware.nixosModules.common-pc-ssd
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-cpu-amd-pstate
  ];

  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  services.monero = {
    enable = true;
    extraConfig = ''
      # prune-blockchain=1
      # sync-pruned-blocks=1
      db-sync-mode=safe
      confirm-external-bind=1
    '';
    rpc = {
      address = "100.120.92.101";
    };
  };

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  system.stateVersion = "22.11";
}

