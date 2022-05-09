{ pkgs, ... }: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 3;

      systemd-boot = {
        enable= true;
        consoleMode = "max";
        editor = false;
        memtest86.enable = true;
      };
    };

    cleanTmpDir = true;
  };
}

