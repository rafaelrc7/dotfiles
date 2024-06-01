{ inputs, ... }:
final: prev: {
  hyprland = inputs.nixpkgs-hyprland.legacyPackages."${final.system}".hyprland;
}

