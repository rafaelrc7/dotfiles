{
  description = "My NixOS configurations and dotfiles flake";

  inputs = rec {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs";
    nixpkgs = nixpkgs-unstable;

    nixos-hardware = {
      url = "github:nixos/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    awesome-git = {
      flake = false;
      url = "github:awesomewm/awesome";
    };

    awesomerc = {
      url = "github:rafaelrc7/awesomerc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, nixos-hardware, ... }:
  let
    utils = import ./utils inputs;
  in {
    nixosConfigurations = {
      "spitfire" = utils.mkHost {
        hostName = "spitfire";
        system = "x86_64-linux";
        userNames = [ "rafael" ];
        nixosModuleNames = [ "nix.nix" "zsh.nix" "dnscrypt.nix" ];
        extraModules = [ nixos-hardware.nixosModules.common-cpu-intel
                         nixos-hardware.nixosModules.common-pc-laptop
        ];
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

