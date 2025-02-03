{ pkgs, ... }:
{
  imports = [
    ./gamescope.nix
  ];

  environment.systemPackages = with pkgs; [
    heroic
    mangohud
  ];

  programs.gamemode.enable = true;
}
