{ lib, ... }:
{
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 3;

      systemd-boot = {
        enable = true;
        consoleMode = "max";
        editor = false;
        memtest86.enable = lib.mkDefault true;
      };

      grub.enable = lib.mkForce false;
    };
  };
}
