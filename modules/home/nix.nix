{ inputs, lib, pkgs, ... }: {
  nix = {
    package = lib.mkDefault pkgs.nixUnstable;

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      max-jobs = "auto";
      cores = 0;
    };

    gc = {
      automatic = true;
      frequency = "weekly";
      options = "--delete-older-than 7d";
    };

    registry.nixpkgs.flake = inputs.nixpkgs;
  };
}

