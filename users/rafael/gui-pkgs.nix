{ pkgs, ... }: {
  home.packages = with pkgs; [
    (discord.override { nss = nss_latest; })
    (discord-canary.override { nss = nss_latest; })
    vesktop
    calibre
    gimp
    gnome-disk-utility
    helvum
    jami
    libreoffice-fresh
    obsidian
    pavucontrol
    qutebrowser
    spotify
    tdesktop
    ungoogled-chromium
  ];
}

