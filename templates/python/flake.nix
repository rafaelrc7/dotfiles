{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.flake-parts.flakeModules.easyOverlay
      ];

      perSystem =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        {
          packages = rec {
            default = hello;
            hello = pkgs.python3Packages.callPackage ./default.nix { };
          };

          apps.default = {
            type = "app";
            program = "${config.packages.default}/bin/main.py";
          };

          overlayAttrs = {
            inherit (config.packages) hello;
          };

          devShells.default = import ./shell.nix {
            inherit pkgs;
            inputsFrom = lib.attrsets.attrValues config.packages;
          };

          treefmt.config = {
            projectRootFile = "flake.nix";
            programs = {
              isort.enable = true;
              nixfmt.enable = true;
              prettier.enable = true;
              ruff-check.enable = true;
              ruff-format.enable = true;
            };
          };
        };
    };
}
