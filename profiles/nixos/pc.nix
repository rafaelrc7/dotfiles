nixosModules: {
  imports = with nixosModules; [
    android
    btrfs
    catppuccin
    fcitx5
    flatpak
    gparted
    hyprland-uwsm
    pipewire
  ];
}
