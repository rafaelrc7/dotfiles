args@{ pkgs, ... }:
{
  accounts.email.accounts = builtins.mapAttrs (account: module: import module args) (
    args.self.lib.findModules ./.
  );
}
