{ lib, ... }: {
  services.xserver = {
    desktopManager.plasma5 = {
      enable = true;
      runUsingSystemd = true;
    };

    layout = lib.mkDefault "us";
  };
}

