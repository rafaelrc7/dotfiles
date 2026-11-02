{ pkgs, ... }:
{
  home.packages = with pkgs; [
    anki
    calibre
    crosspipe
    discord
    gimp
    google-chrome
    jami
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
