{ pkgs, ... }:
{
  home.packages = with pkgs; [
    calibre
    (discord.override { nss = nss_latest; })
    gimp
    gnome-disk-utility
    google-chrome
    helvum
    jami
    libreoffice-fresh
    obsidian
    protonmail-desktop
    pwvucontrol
    qbittorrent
    qutebrowser
    spotify
    telegram-desktop
    thunderbird
  ];
}
