{ ... }: {

  swapDevices = [
    {
      device = "/dev/disk/by-partlabel/cryptswap";
      randomEncryption.enable = true;
      randomEncryption.allowDiscards = true;
    }
  ];

}

