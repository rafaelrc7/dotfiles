{ inputs, ... }:
final: prev: {
  calibre = inputs.nixpkgs-prev.legacyPackages."${final.system}".calibre;
}

