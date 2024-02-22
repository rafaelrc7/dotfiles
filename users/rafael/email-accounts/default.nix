args@{ self, lib, ... }: with builtins; mapAttrs (user: module: import module args) (self.lib.findModules ./.)

