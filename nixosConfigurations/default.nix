{
  lib,
  self,
  inputs,
  ...
}:
builtins.mapAttrs (host: module: import module { inherit lib self inputs; }) (lib.findModules ./.)
