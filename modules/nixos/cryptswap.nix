{ ... }: {

  swapDevices = [
    { device = "/dev/mapper/swap"; }
  ];

  boot.initrd.luks.reusePassphrases = true;
  boot.initrd.luks.devices = {
    "swap".device = "/dev/disk/by-partlabel/cryptswap";
  };

}

