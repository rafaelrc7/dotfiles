{ lib, nixosModules, ... }:
builtins.mapAttrs (_: value: import value nixosModules) (lib.findModules ./.)
