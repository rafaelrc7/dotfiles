{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
in
{
  nix = {
    package = pkgs.nixVersions.latest;

    settings = {
      trusted-users = [
        "root"
        "@wheel"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations"
      ];
      system-features = [
        "kvm"
        "big-parallel"
        "nixos-test"
      ];
      warn-dirty = false;
      auto-optimise-store = lib.mkDefault true;
      max-jobs = "auto";
      cores = 0;
      flake-registry = ""; # Disable global flake registry
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };
}
