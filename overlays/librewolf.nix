{ inputs, ... }:
final: prev: {
  librewolf = inputs.nixpkgs-master.legacyPackages."${final.system}".librewolf;
}

