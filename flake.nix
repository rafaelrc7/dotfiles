{
  description = "My NixOS configurations and dotfiles flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs";
    nixpkgs-prev.url = "github:nixos/nixpkgs/d3c42f187194c26d9f0309a8ecc469d6c878ce33";
    nixpkgs-bisq.url = "github:nixos/nixpkgs/c31898adf5a8ed202ce5bea9f347b1c6871f32d1";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";

    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    nur.url = "github:nix-community/nur";
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

    vscoq.url = "github:coq-community/vscoq";

    awesome-git = {
      url = "github:awesomewm/awesome";
      flake = false;
    };

    proton-bridge = {
      url = "github:rafaelrc7/proton-bridge";
      flake = false;
    };

    # neovim plugins
    remote-nvim = {
      url = "github:amitds1997/remote-nvim.nvim";
      flake = false;
    };
  };

  outputs =
    inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.treefmt-nix.flakeModule
        ./modules/nixos
        ./modules/home
        ./overlays
        ./users
        ./hosts
        ./lib
      ];

      flake = {
        nixosConfigurations = {
          vulcan = self.lib.mkHost {
            hostName = "vulcan";
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
                sshKeys = import ./users/rafael/sshkeys.nix;
              }
            ];
          };

          lancaster = self.lib.mkHost {
            hostName = "lancaster";
            users = [
              {
                name = "rafael";
                extraGroups = [
                  "wheel"
                  "adbusers"
                  "libvirtd"
                  "dialout"
                  "podman"
                ];
                sshKeys = import ./users/rafael/sshkeys.nix;
                extraArgs = {
                  crypto = null;
                  email = null;
                  firefox = null;
                  go = null;
                  gschemas = null;
                  gui-pkgs = null;
                  hyprland = null;
                  jetbrains = null;
                  kitty = null;
                  librewolf = null;
                  mpd = null;
                  mpv = null;
                  neomutt = null;
                  node = null;
                  protonmail-bridge = null;
                  rclone-gdrive = null;
                  sway = null;
                  udiskie = null;
                  obs = null;
                  vscode = null;
                  zathura = null;
                };
              }
            ];
          };

          spitfire = self.lib.mkHost {
            hostName = "spitfire";
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
                sshKeys = import ./users/rafael/sshkeys.nix;
              }
            ];
          };
        };

        homeConfigurations = {
          rafael = self.lib.mkHome {
            system = "x86_64-linux";
            username = "rafael";
          };
        };

      };

      systems = [ "x86_64-linux" ];
      perSystem =
        { pkgs, system, ... }:
        {
          devShells = {
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

}
