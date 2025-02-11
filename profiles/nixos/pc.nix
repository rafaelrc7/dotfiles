nixosModules: {
  imports = with nixosModules; [
    android
    btrfs
    flatpak
    hyprland-uwsm
    pipewire
  ];
}
