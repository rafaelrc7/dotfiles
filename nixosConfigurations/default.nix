{
  lib,
  self,
  inputs,
  ...
}:
builtins.mapAttrs (host: module: import module { inherit self inputs; }) (lib.findModules ./.)
