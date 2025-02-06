{
  inputs,
  self,
  ...
}:
{
  networking.hostName = "spitfire";

  imports =
    [
      ./gpu.nix
      ./hardware-configuration.nix
      ./networking.nix
      ./printer.nix
    ]
    ++ (with self.nixosProfiles; [
      base
      pc
      gaming
      laptop
    ])
    ++ (with self.nixosModules; [
      cryptswap
      systemd-boot

      java
      mullvad
      podman
      rtl-sdr
      udev-media-keys
      urserver
    ])
    ++ (with inputs; [
      nixos-hardware.nixosModules.common-cpu-intel
      "${nixos-hardware}/common/gpu/intel/tiger-lake"
      nixos-hardware.nixosModules.common-pc-laptop
      nixos-hardware.nixosModules.common-pc-laptop-ssd
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
