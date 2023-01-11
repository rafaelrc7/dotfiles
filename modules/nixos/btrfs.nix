{ pkgs, ... }:
let mountOps = [ "compress=zstd" "noatime" "nodiratime" "discard=async" ];
in {

  fileSystems."/".options           = mountOps;
  fileSystems."/home".options       = mountOps;
  fileSystems."/root".options       = mountOps;
  fileSystems."/tmp".options        = mountOps;
  fileSystems."/.snapshots".options = mountOps;
  fileSystems."/var".options        = [ "compress=zstd" "discard" ];

  swapDevices = [
    { device = "/dev/disk/by-partlabel/cryptswap"; randomEncryption.enable = true; }
  ];

  boot.initrd.supportedFilesystems = [ "btrfs" ];
  environment.systemPackages = with pkgs; [ btrfs-progs compsize ];
}

