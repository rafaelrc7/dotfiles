{
  nixos-hardware,
  nixosModules,
  nixosProfiles,
  ...
}:
{
  networking.hostName = "spitfire";
  boot.initrd.systemd.enable = true;

  imports =
    [
      ./gpu.nix
      ./hardware-configuration.nix
      ./networking.nix
      ./printer.nix
    ]
    ++ (with nixosProfiles; [
      base
      pc
      gaming
      laptop
    ])
    ++ (with nixosModules; [
      cryptswap
      systemd-boot
      zram

      java
      mullvad
      podman
      rtl-sdr
      udev-media-keys
      urserver
    ])
    ++ (with nixos-hardware.nixosModules; [
      common-pc-laptop
      common-pc-laptop-ssd
      common-cpu-intel
      "${nixos-hardware}/common/gpu/intel/tiger-lake"
    ]);

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
