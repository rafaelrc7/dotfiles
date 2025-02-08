{
  inputs,
  lib,
  self,
  ...
}:
let
  users = {
    rafael = {
      gui = true;
      sshKeys = lib.strings.splitString "\n" (builtins.readFile inputs.ssh-keys);
      extraGroups = [
        "adbusers"
        "dialout"
        "libvirtd"
        "plugdev"
        "podman"
        "wheel"
      ];
    };
  };
in
self.lib.mkNixosConfiguration {
  system = "x86_64-linux";
  configuration = ./configuration.nix;
  inherit users;
}
