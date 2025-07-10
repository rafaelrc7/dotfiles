{ pkgs, ... }:
{
  home.packages = with pkgs; [
    discord
    calibre
    gimp
    gnome-disk-utility
    helvum
    jami
    libreoffice-fresh
    obsidian
    pwvucontrol
    protonmail-desktop
    qbittorrent
    qutebrowser
    spotify
    tdesktop
    thunderbird
    ungoogled-chromium
  ];
}
