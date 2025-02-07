{ lib, inputs, ... }: builtins.mapAttrs (_: value: import value inputs) (lib.findModules ./.)
