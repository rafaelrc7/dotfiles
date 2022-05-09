{ pkgs, ... }: {

  fileSystems."/".options           = [ "compress=zstd" "noatime" "nodiratime" "discard" ];
  fileSystems."/home".options       = [ "compress=zstd" "noatime" "nodiratime" "discard" ];
  fileSystems."/root".options       = [ "compress=zstd" "noatime" "nodiratime" "discard" ];
  fileSystems."/tmp".options        = [ "compress=zstd" "noatime" "nodiratime" "discard" ];
  fileSystems."/.snapshots".options = [ "compress=zstd" "noatime" "nodiratime" "discard" ];
  fileSystems."/var".options        = [ "compress=zstd" "discard" ];

  swapDevices = [
    { device = "/dev/disk/by-partlabel/cryptswap"; randomEncryption.enable = true; }
  ];

  boot.initrd.supportedFilesystems = [ "btrfs" ];
  environment.systemPackages = with pkgs; [ btrfs-progs compsize ];
}

