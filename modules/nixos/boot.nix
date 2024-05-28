{ pkgs, lib, ... }:
let inherit (lib) mkDefault;
in {
  boot = {
    kernelPackages = mkDefault pkgs.linuxPackages_latest;

    supportedFilesystems = mkDefault [ "vfat" "btrfs" "ext4 " ];

    loader = {
      efi.canTouchEfiVariables = mkDefault true;
      timeout = mkDefault 3;

      systemd-boot = {
        enable = mkDefault true;
        consoleMode = "max";
        editor = mkDefault false;
        memtest86.enable = mkDefault true;
      };
    };

    tmp.cleanOnBoot = mkDefault true;
  };
}

