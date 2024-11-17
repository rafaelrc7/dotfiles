{ inputs, ... }:
final: prev: {
  hyprland = inputs.nixpkgs-prev.legacyPackages."${final.system}".hyprland;
}

