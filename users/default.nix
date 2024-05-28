{ self, ... } @ args:
let
  inherit (builtins) mapAttrs;
  inherit (self.lib) findModules;
in
{
  flake.users = mapAttrs (user: module: import module args) (findModules ./.);
}

