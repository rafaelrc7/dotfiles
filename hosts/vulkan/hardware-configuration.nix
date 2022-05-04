{ config, lib, pkgs, modulesPath, ... }: {
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-partlabel/cryptroot";

  fileSystems."/home" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  fileSystems."/.snapshots" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=@snapshots" ];
    };

  fileSystems."/var" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=@var" ];
    };

  fileSystems."/root" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=@root" ];
    };

  fileSystems."/tmp" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=@tmp" ];
    };

  fileSystems."/nix/store" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=@nix_store" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-partlabel/EFI";
      fsType = "vfat";
    };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

