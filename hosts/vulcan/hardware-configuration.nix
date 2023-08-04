{ config, lib, pkgs, modulesPath, ... }:
let btrfsDefaultOps = [ "defaults" "compress=zstd" "discard=async" "noatime" "nodiratime" ];
    btrfsDefaultSSDOps = [ "ssd" ] ++ btrfsDefaultOps;
in {
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "cryptd" "aesni_intel" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" "v4l2loopback" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

  environment.systemPackages = with pkgs; [ v4l-utils ];

  boot.initrd.luks.reusePassphrases = true;
  boot.initrd.luks.devices = {
    "root".device = "/dev/disk/by-partlabel/cryptroot";
    "snd".device = "/dev/disk/by-partlabel/cryptsnd";
  };

  fileSystems."/" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=@" ] ++ btrfsDefaultSSDOps;
    };

  fileSystems."/home" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=@home" ] ++ btrfsDefaultSSDOps;
    };

  fileSystems."/root" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=@root" ] ++ btrfsDefaultSSDOps;
    };

  fileSystems."/tmp" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=@tmp" "ssd" ];
    };

  fileSystems."/var" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=@var" "ssd" "compress=zstd" ];
    };

  fileSystems."/nix" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=@nix" ] ++ btrfsDefaultSSDOps;
    };

  fileSystems."/.snapshots" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=@snapshots" ] ++ btrfsDefaultSSDOps;
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/EA94-FCDF";
      fsType = "vfat";
    };

  fileSystems."/media/backup" =
    { device = "/dev/disk/by-partlabel/backup";
      fsType = "btrfs";
      options = [ "subvol=@" ] ++ btrfsDefaultOps;
    };

  fileSystems."/media/snd" =
    { device = "/dev/mapper/snd";
      fsType = "btrfs";
      options = [ "subvol=@" ] ++ btrfsDefaultOps;
    };

  fileSystems."/media/thd" =
    { device = "/dev/disk/by-uuid/519d60bc-9e95-44c5-ad1d-346077cc3ca4";
      fsType = "ext4";
    };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp42s0.useDHCP = lib.mkDefault true;

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

