{ self, ... }:
{
  flake.homeModules = self.lib.findModules ./.;
}
