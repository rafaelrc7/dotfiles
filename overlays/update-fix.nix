inputs: final: prev: {
  sdrpp = inputs.nixpkgs-prev.legacyPackages."${final.system}".sdrpp;
  rocmPackages = inputs.nixpkgs-prev.legacyPackages."${final.system}".rocmPackages;
}
