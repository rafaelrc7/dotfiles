args@{ self, ... }: builtins.mapAttrs (user: module: import module args) (self.lib.findModules ./.)

