{ pkgs, ... }: {
  home.packages = with pkgs; [
    gimp
    libreoffice-fresh
    obsidian
    slack
    spotify
  ];
}

