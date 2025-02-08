{ lib, homeModules, ... }:
builtins.mapAttrs (_: value: import value homeModules) (lib.findModules ./.)
