{
  description = "My NixOS configurations and dotfiles flake";

  outputs =
    inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.home-manager.flakeModules.home-manager
        ./lib
      ];

      flake = {
        nixosModules = import ./modules/nixos { inherit (self) lib; };
        nixosProfiles = import ./profiles/nixos { inherit (self) nixosModules lib; };

        homeModules = import ./modules/home { inherit (self) lib; };
        homeProfiles = import ./profiles/home { inherit (self) homeModules lib; };

        users = import ./users {
          inherit (self) lib;
          inherit self inputs;
        };

        nixosConfigurations = import ./hosts {
          inherit (self) lib;
          inherit self inputs;
        };

        homeConfigurations = builtins.mapAttrs (
          username: userModule:
          self.lib.mkHomeConfiguration {
            inherit
              username
              userModule
              ;
          }
        ) self.users;

        overlays =
          let
            overlays = import ./overlays {
              inherit (self) lib;
              inherit inputs;
            };
          in
          overlays
          // {
            default = self.lib.composeManyExtensions (builtins.attrValues overlays);
          };

        templates = import ./templates { };
      };

      perSystem =
        { pkgs, system, ... }:
        {
          devShells = {
            default = import ./shell.nix { inherit pkgs; };
            bootstrap = import ./bootstrap.nix { inherit pkgs system; };
          };

          packages = import ./pkgs { inherit pkgs; };

          treefmt.config = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
              prettier.enable = true;
              stylua.enable = true;
            };
          };
        };
    };

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos-cuda.org"
      "https://hyprland.cachix.org"
      "https://catppuccin.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";
    nur.inputs.flake-parts.follows = "flake-parts";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bisq-for-nixos.url = "github:emmanuelrosa/bisq-for-nixos";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprlock.url = "github:hyprwm/hyprlock";

    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";

    catppuccin.url = "github:catppuccin/nix";

    awesomerc.url = "github:rafaelrc7/awesomerc";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";

    nixgl.url = "github:guibou/nixgl";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";

    wayland-pipewire-idle-inhibit.url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
    wayland-pipewire-idle-inhibit.inputs.nixpkgs.follows = "nixpkgs";
    wayland-pipewire-idle-inhibit.inputs.flake-parts.follows = "flake-parts";
    wayland-pipewire-idle-inhibit.inputs.treefmt-nix.follows = "treefmt-nix";

    ssh-keys = {
      url = "https://github.com/rafaelrc7.keys";
      flake = false;
    };

    awesome-git = {
      url = "github:awesomewm/awesome";
      flake = false;
    };

    amdgpu-fullrgb-patch = {
      url = "git+https://gist.github.com/rafaelrc7/0270037dbe86205365ec8b7a4f339f82?ref=refs/tags/v6.14";
      flake = false;
    };

    nix-minecraft-servers.url = "github:rafaelrc7/nix-minecraft-servers";
  };

}
