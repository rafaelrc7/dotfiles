nixosModules: {
  imports = with nixosModules; [
    android
    btrfs
    catppuccin
    fcitx5
    flatpak
    hyprland-uwsm
    pipewire
  ];
}
