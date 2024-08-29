{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    lutris
  ];

  programs.gamescope.enable = true;
  programs.gamemode.enable = true;
}

