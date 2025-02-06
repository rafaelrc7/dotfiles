{ self, ... }:
{
  imports = with self.nixosModules; [
    android
    btrfs
    flatpak
    pipewire
  ];
}
