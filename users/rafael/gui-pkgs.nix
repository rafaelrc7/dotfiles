{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (discord.override { nss = nss_latest; })
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
