{ pkgs, ... }:
{
  home.packages = with pkgs; [
    anki
    calibre
    crosspipe
    (discord.override { nss = nss_latest; })
    gimp
    gnome-disk-utility
    google-chrome
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
