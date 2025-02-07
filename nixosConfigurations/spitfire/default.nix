{ self, inputs }:
let
  inherit (inputs) nixpkgs;
  users = [
    {
      name = "rafael";
      extraGroups = [
        "wheel"
        "adbusers"
        "libvirtd"
        "dialout"
        "podman"
        "plugdev"
      ];
      sshKeys = import ../../users/rafael/sshkeys.nix;
    }
  ];
in
import ./configuration.nix

  nixpkgs.lib.nixosSystem
  {
    system = "x86_64-linux";
    specialArgs = {
      inherit inputs;
      inherit (self) nixosModules nixosProfiles;
      inherit (inputs) home-manager nur nixos-hardware;
    };
    modules = [
      (import ./configuration.nix)
      inputs.home-manager.nixosModules.home-manager
      inputs.catppuccin.nixosModules.catppuccin
      (self.lib.nixpkgsConfig { })

      (self.lib.mkUsers users)
      {
        home-manager = {
          useUserPackages = true;
          useGlobalPkgs = true;
          extraSpecialArgs = { inherit inputs nixpkgs self; };
          users = self.lib.mkHMUsers users;
        };
      }
    ];
  }
