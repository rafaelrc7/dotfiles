{ self, inputs, ... }:
{
  networking.hostName = "lancaster";

  imports =
    (with self.nixosModules; [
      ./hardware-configuration.nix
      ./networking.nix

      btrfs
      common
      ddclient
      fonts
      geoclue
      git
      man
      nightscout
      nix
      palserver
      podman
      polkit
      ssh
      systemd-oomd
      tailscale
      zsh
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

  programs.dconf.enable = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  system.stateVersion = "22.11";
}
