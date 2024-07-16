{ pkgs, ... }: {
  home.packages = with pkgs; [
    (discord.override { nss = nss_latest; })
    vesktop
    calibre
    gimp
    gnome-disk-utility
    helvum
    nixpkgs-stable.jami
    libreoffice-fresh
    obsidian
    pavucontrol
    qutebrowser
    slack
    spotify
    tdesktop
    ungoogled-chromium
  ];
}

