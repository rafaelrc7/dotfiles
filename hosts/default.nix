{ self, ... } @ args: with builtins; with self.lib; {
  flake.hosts = mapAttrs (host: module: import module args) (findModules ./.);
}

