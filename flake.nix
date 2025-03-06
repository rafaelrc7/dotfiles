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

        overlays = import ./overlays {
          inherit (self) lib;
          inherit inputs;
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
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";

    hyprland.url = "github:hyprwm/Hyprland/f261fb6fe028a1427cfd672eee6e7d5705cd696f";

    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    catppuccin.url = "github:rafaelrc7/catppuccin-nix";

    awesomerc.url = "github:rafaelrc7/awesomerc";

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

    ssh-keys = {
      url = "https://github.com/rafaelrc7.keys";
      flake = false;
    };

    awesome-git = {
      url = "github:awesomewm/awesome";
      flake = false;
    };

    proton-bridge = {
      url = "github:rafaelrc7/proton-bridge";
      flake = false;
    };

    amdgpu-fullrgb-patch = {
      url = "git+https://gist.github.com/rafaelrc7/0270037dbe86205365ec8b7a4f339f82";
      flake = false;
    };
  };

}
