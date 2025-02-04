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
        let
          go = pkgs.go;
          buildGoModule = pkgs.buildGoModule.override { inherit go; };
        in
        {
          packages = rec {
            default = hello;
            hello = pkgs.callPackage ./default.nix { inherit buildGoModule; };
          };

          apps.default = {
            type = "app";
            program = "${config.packages.default}/bin/hello";
          };

          overlayAttrs = {
            inherit (config.packages) hello;
          };

          devShells.default = import ./shell.nix {
            inherit go buildGoModule pkgs;
            inputsFrom = lib.attrsets.attrValues config.packages;
          };

          treefmt.config = {
            projectRootFile = "flake.nix";
            programs = {
              gofmt.enable = true;
              goimports.enable = true;
              nixfmt.enable = true;
              prettier.enable = true;
            };
          };
        };
    };
}
