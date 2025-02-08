{ lib, ... }: builtins.mapAttrs (user: module: import module) (lib.findModules ./.)
