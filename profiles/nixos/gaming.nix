nixosModules: {
  imports = with nixosModules; [
    gpu-screen-recorder
    heroic
    lutris
    steam
    wine
  ];
}
