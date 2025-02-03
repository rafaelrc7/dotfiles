{ inputs, ... }:
final: prev: {
  nixpkgs-stable = inputs.nixpkgs-stable.legacyPackages."${final.system}";
  nixpkgs-unstable = inputs.nixpkgs-unstable.legacyPackages."${final.system}";
  nixpkgs-master = inputs.nixpkgs-master.legacyPackages."${final.system}";
}
