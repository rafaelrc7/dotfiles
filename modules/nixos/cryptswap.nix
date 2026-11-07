{ config, ... }:
{
  swapDevices = [
    {
      label = "swap";
      encrypted = {
        enable = true;
        label = "swap";
        blkDev = "/dev/disk/by-partlabel/cryptswap";
      };
      discardPolicy = if config.boot.initrd.luks.devices."swap".allowDiscards then "both" else null;
    }
  ];
}
