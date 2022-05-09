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
      options = [ "subvol=@" "ssd" ];
    };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-partlabel/cryptroot";

  fileSystems."/home" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=@home" "ssd" ];
    };

  fileSystems."/.snapshots" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=@snapshots" "ssd" ];
    };

  fileSystems."/var" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=@var" "ssd" ];
    };

  fileSystems."/root" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=@root" "ssd" ];
    };

  fileSystems."/tmp" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=@tmp" "ssd" ];
    };

  fileSystems."/nix/store" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=@nix_store" "ssd" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-partlabel/EFI";
      fsType = "vfat";
    };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

