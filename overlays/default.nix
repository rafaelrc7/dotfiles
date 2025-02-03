args@{ self, ... }:
{
  flake.overlays = builtins.mapAttrs (_: value: import value args) (self.lib.findModules ./.);
}
