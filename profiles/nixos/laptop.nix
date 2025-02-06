{ self, ... }:
{
  imports = with self.nixosModules; [
    bluetooth
    powertop
    screen-brightness
    tlp
  ];
}
