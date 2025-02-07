nixosModules: {
  imports = with nixosModules; [
    bluetooth
    powertop
    screen-brightness
    tlp
  ];
}
