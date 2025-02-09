{
  inputs,
  lib,
  self,
  ...
}:
let
  users = {
    rafael = {
      gui = false;
      sshKeys = lib.strings.splitString "\n" (builtins.readFile inputs.ssh-keys);
      profiles = (with self.homeProfiles; [ base ]);
      extraGroups = [
        "adbusers"
        "dialout"
        "libvirtd"
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
