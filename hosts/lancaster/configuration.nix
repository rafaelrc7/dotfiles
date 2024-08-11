{ self, inputs, ... }:
{
  networking.hostName = "lancaster";

  imports =
    (with self.nixosModules; [
      ./hardware-configuration.nix
      ./networking.nix

      common
      bitcoind
      btrfs
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

  services.monero.rpc = {
    address = "100.120.92.101"; # tailscale IP
  };

  # Monero RPC Port
  networking.firewall.interfaces."${config.services.tailscale.interfaceName}".allowedTCPPorts = [ 18081 ];

  system.stateVersion = "22.11";
}
