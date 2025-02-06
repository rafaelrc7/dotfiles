{ self, ... }:
{
  imports = with self.nixosModules; [
    gpu-screen-recorder
    heroic
    lutris
    steam
    wine
  ];
}
