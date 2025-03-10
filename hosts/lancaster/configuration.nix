{ self, inputs, ... }:
{
  networking.hostName = "lancaster";

  imports =
    (with self.nixosModules; [
      ./hardware-configuration.nix
      ./networking.nix

      common
      btrfs
      ddclient
      geoclue
      nix
      zsh
      podman
      fonts
      man
      nightscout
      ssh
      git
      polkit
      tailscale
      palserver
      systemd-oomd
    ])
    ++ (with inputs; [
      nixos-hardware.nixosModules.common-pc
      nixos-hardware.nixosModules.common-pc-ssd
      nixos-hardware.nixosModules.common-cpu-amd
      nixos-hardware.nixosModules.common-cpu-amd-pstate
    ]);

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

  programs.dconf.enable = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  system.stateVersion = "22.11";
}
