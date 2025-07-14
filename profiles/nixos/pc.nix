nixosModules: {
  imports = with nixosModules; [
    android
    btrfs
    catppuccin
    flatpak
    hyprland-uwsm
    pipewire
  ];
}
