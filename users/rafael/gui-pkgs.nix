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
    qbittorrent
    qutebrowser
    spotify
    tdesktop
    ungoogled-chromium
  ];
}
