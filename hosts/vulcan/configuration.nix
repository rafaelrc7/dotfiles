{
  inputs,
  pkgs,
  self,
  ...
}:
{
  networking.hostName = "vulcan";
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

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
    ])
    ++ (with self.nixosModules; [
      cryptswap
      systemd-boot

      guix
      java
      libvirtd
      llm
      mullvad
      podman
      rtl-sdr
      waydroid
    ])
    ++ (with inputs.nixos-hardware.nixosModules; [
      common-pc
      common-pc-ssd
      common-gpu-amd
      common-cpu-amd
      common-cpu-amd-pstate
    ]);

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

  systemd.services.nix-daemon.serviceConfig.AllowedCPUs = "2-15";

  system.stateVersion = "22.11";
}
