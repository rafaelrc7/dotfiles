{ inputs, pkgs, ... }: {
  environment.etc = {
    "nix/channels/nixpkgs".source = inputs.nixpkgs;
    "nix/channels/nixpkgs-stable".source = inputs.nixpkgs-stable;
    "nix/channels/nixpkgs-unstable".source = inputs.nixpkgs-unstable;
    "nix/channels/home-manager".source = inputs.home-manager;
  };

  nix = {
    package = pkgs.nixUnstable;

    nixPath = [
      "nixpkgs=/etc/nix/channels/nixpkgs"
      "nixpkgs-stable=/etc/nix/channels/nixpkgs-stable"
      "nixpkgs-unstable=/etc/nix/channels/nixpkgs-unstable"
      "home-manager=/etc/nix/channels/home-manager"
    ];

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    registry.nixpkgs.flake = inputs.nixpkgs;
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      max-jobs = "auto";
      cores = 0;
    };
  };
}

