# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "ahci"
    "ohci_pci"
    "ehci_pci"
    "pata_atiixp"
    "xhci_pci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/31329abd-0302-4840-8ab3-7327a985bdf6";
    fsType = "btrfs";
    options = [ "subvol=@" ];
  };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/3555721b-aa75-40d4-90c3-970e77c55cab";

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/31329abd-0302-4840-8ab3-7327a985bdf6";
    fsType = "btrfs";
    options = [ "subvol=@nix" ];
  };

  fileSystems."/tmp" = {
    device = "/dev/disk/by-uuid/31329abd-0302-4840-8ab3-7327a985bdf6";
    fsType = "btrfs";
    options = [ "subvol=@tmp" ];
  };

  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/31329abd-0302-4840-8ab3-7327a985bdf6";
    fsType = "btrfs";
    options = [ "subvol=@var" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/31329abd-0302-4840-8ab3-7327a985bdf6";
    fsType = "btrfs";
    options = [ "subvol=@home" ];
  };

  fileSystems."/root" = {
    device = "/dev/disk/by-uuid/31329abd-0302-4840-8ab3-7327a985bdf6";
    fsType = "btrfs";
    options = [ "subvol=@root" ];
  };

  fileSystems."/.snapshots" = {
    device = "/dev/disk/by-uuid/31329abd-0302-4840-8ab3-7327a985bdf6";
    fsType = "btrfs";
    options = [ "subvol=@snapshots" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F4FD-DB6D";
    fsType = "vfat";
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
