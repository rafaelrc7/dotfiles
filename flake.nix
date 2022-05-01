{
  description = "My NixOS configurations and dotfiles flake";

  inputs = rec {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs";
    nixpkgs = nixpkgs-unstable;

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-config = {
      flake = false;
      url = "github:rafaelrc7/nvimrc";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
  let
    utils = import ./utils inputs;
  in {
    nixosConfigurations = {
      "vulkan" = utils.mkHost {
        hostName = "vulkan";
        system = "x86_64-linux";
        userNames = [ "rafael" ];
        nixosModuleNames = [ "zsh.nix" ];
      };
    };

    homeConfigurations = {
      "rafael" = utils.mkHome {
        system = "x86_64-linux";
        username = "rafael";
        homeModules = [
          ({ pkgs, ... }: {
            programs.kitty.package = pkgs.hello;
          })
        ];
      };
    };
  };
}

