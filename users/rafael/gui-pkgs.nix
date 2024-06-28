{ pkgs, ... }: {
  home.packages = with pkgs; [
    (discord.override { nss = nss_latest; })
    vesktop
    calibre
    gimp
    gnome.gnome-disk-utility
    helvum
    jami
    libreoffice-fresh
    obsidian
    pavucontrol
    qutebrowser
    slack
    spotify
    tdesktop
    ungoogled-chromium
    zoom-us
  ];
}

