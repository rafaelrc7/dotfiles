nixosModules: {
  imports = with nixosModules; [
    gpu-screen-recorder
    heroic
    steam
    wine
  ];
}
