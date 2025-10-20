inputs: final: prev: {
  sdrpp = inputs.nixpkgs-prev.legacyPackages."${final.system}".sdrpp;
}
