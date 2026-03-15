{
  nixos-hardware,
  nixosModules,
  nixosProfiles,
  config,
  ...
}:
{
  networking.hostName = "lancaster";

  imports = [
    ./hardware-configuration.nix
    ./networking.nix
  ]
  ++ (with nixosProfiles; [
    base
  ])
  ++ (with nixosModules; [
    btrfs
    ddclient
    git
    nightscout
    palserver
    podman
    zram
  ])
  ++ (with nixos-hardware.nixosModules; [
    common-pc
    common-pc-ssd
    common-cpu-amd
    common-cpu-amd-pstate
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
  networking.firewall.interfaces."${config.services.tailscale.interfaceName}".allowedTCPPorts = [
    18081
  ];

  system.stateVersion = "22.11";
}
