{ pkgs, ... }:
{
  documentation = {
    man.enable = true;
    man.generateCaches = true;
    dev.enable = true;
    nixos.enable = true;
  };

  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix
    stdmanpages
  ];
}
