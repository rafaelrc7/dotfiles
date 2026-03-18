{ pkgs, ... }:
{
  documentation = {
    man.enable = true;
    man.cache.enable = true;
    dev.enable = true;
    nixos.enable = true;
  };

  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix
    stdmanpages
  ];
}
