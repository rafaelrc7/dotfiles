{ self, ... } @ args: with builtins; with self.lib; {
  flake.users = mapAttrs (user: module: import module args) (findModules ./.);
}

