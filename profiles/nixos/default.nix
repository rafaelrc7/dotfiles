args@{ self, ... }: builtins.mapAttrs (_: value: import value args) (self.lib.findModules ./.)
