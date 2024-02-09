{ self, ... }: {
  flake.overlays = builtins.mapAttrs (_: value: import value) (self.lib.findModules ./.);
}

