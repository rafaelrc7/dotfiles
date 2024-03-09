{ pkgs, ... }: {
  home.packages = with pkgs; [
    (discord.override { nss = nss_latest; })
    calibre
    gimp
    gnome.gnome-disk-utility
    helvum
    libreoffice-fresh
    obsidian
    pavucontrol
    qutebrowser
    slack
    spotify
    tdesktop
    ungoogled-chromium
    zathura
  ];
}

