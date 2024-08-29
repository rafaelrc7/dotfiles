{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    heroic
    mangohud
  ];

  programs.gamescope.enable = true;
  programs.gamemode.enable = true;
}

