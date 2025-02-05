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
      ];

      perSystem =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        let
          name = "doc";
          tex = (
            pkgs.texlive.combine {
              inherit (pkgs.texlive)
                scheme-basic
                collection-bibtexextra
                collection-binextra
                collection-context
                collection-fontsextra
                collection-fontsrecommended
                collection-fontutils
                collection-langenglish
                collection-langportuguese
                collection-latex
                collection-latexextra
                collection-latexrecommended
                collection-luatex
                collection-mathscience
                collection-metapost
                collection-plaingeneric
                abnt
                abntex2
                abntexto
                ;
            }
          );
        in
        {
          packages = {
            default = pkgs.callPackage ./default.nix { inherit name tex; };
          };

          devShells.default = import ./shell.nix {
            inherit pkgs;
            inputsFrom = lib.attrsets.attrValues config.packages;
          };

          treefmt.config = {
            projectRootFile = "flake.nix";
            programs = {
              latexindent.enable = true;
              nixfmt.enable = true;
              prettier.enable = true;
            };
          };
        };
    };
}
