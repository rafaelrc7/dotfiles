{ inputs, lib, pkgs, ... }:
let flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
in {
  nix = {
    package = lib.mkDefault pkgs.nixUnstable;

    settings = {
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
      max-jobs = "auto";
      cores = 0;
      flake-registry = ""; # Disable global flake registry
    };

    gc = {
      automatic = true;
      frequency = "weekly";
      options = "--delete-older-than 7d";
    };

    registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
  };
}

