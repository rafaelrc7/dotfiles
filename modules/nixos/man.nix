{ pkgs, ... }:
{
  documentation = {
    man = {
      enable = true;
      cache.enable = true;
      cache.generateAtRuntime = true;
    };
    dev.enable = true;
    nixos.enable = true;
  };

  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix
    stdmanpages
  ];
}
