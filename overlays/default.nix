{ self, ... } : {
  flake.overlays = self.lib.findModules ./.;
}

