{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    lutris
  ];

  programs.gamescope.enable = true;
}

