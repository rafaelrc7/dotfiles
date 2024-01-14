{
  description = "My NixOS configurations and dotfiles flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";

    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    nix-colors.url = "github:misterio77/nix-colors";
    nur.url = "github:nix-community/nur";

    awesomerc.url = "github:rafaelrc7/awesomerc";
    nvim-config = {
      flake = false;
      url = "github:rafaelrc7/nvimrc";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl = {
      url = "github:guibou/nixgl";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wayland-pipewire-idle-inhibit = {
      url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    awesome-git = {
      flake = false;
      url = "github:awesomewm/awesome";
    };

  };

  outputs = inputs@{ self, flake-parts, nixpkgs, home-manager, nixos-hardware, nixgl, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        #inputs.treefmt-nix.flakeModule
        ./modules/nixos
        ./modules/home
        ./overlays
        ./users
        ./hosts
        ./lib
      ];

      flake = let
        pkgs = self.lib.mkPkgs {
          inherit (inputs) nixpkgs;
          overlays = [
            inputs.nix-vscode-extensions.overlays.default
            inputs.nur.overlay
            inputs.nixgl.overlay
          ];
          config = { permittedInsecurePackages = [ "electron-25.9.0" ]; };
        };
      in{
        nixosConfigurations = {
          vulcan = self.lib.mkHost {
            inherit pkgs;
            hostName = "vulcan";
            users = [
              { name = "rafael";
                extraGroups = [ "wheel" "adbusers" "libvirtd" "dialout" ];
                sshKeys = import ./users/rafael/sshkeys.nix;
              }
            ];
          };

          spitfire = self.lib.mkHost {
            inherit pkgs;
            hostName = "spitfire";
            users = [
              { name = "rafael";
                extraGroups = [ "wheel" "adbusers" "libvirtd" "dialout" ];
                sshKeys = import ./users/rafael/sshkeys.nix;
              }
            ];
          };
        };

      };

      systems = [ "x86_64-linux" ];
      perSystem = { config, pkgs, system, ... }: rec {
        devShells = import ./shell.nix { inherit pkgs system; };
        packages = import ./pkgs { inherit pkgs; };

        #treefmt.config = {
          #projectRootFile = "flake.nix";
          #programs = {
            #nixpkgs-fmt.enable = true;
            #prettier.enable = true;
          #};
        #};
      };
    };

}

