{ self, ... }: {
  flake.nixosModules = self.lib.findModules ./.;
}

