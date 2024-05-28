{ self, ... } @ args: {
  flake.hosts = builtins.mapAttrs (host: module: import module args) (self.lib.findModules ./.);
}

