{ pkgs, ... }: {
  imports = [
    ./gamescope.nix
  ];

  environment.systemPackages = with pkgs; [
    lutris
  ];

  programs.gamemode.enable = true;
}

