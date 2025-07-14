{ pkgs, ... }:
{
  catppuccin = {
    enable = true;
    accent = "blue";
    flavor = "mocha";
    cache.enable = true;
  };

  programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
}
