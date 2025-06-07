inputs: final: prev: {
  neomutt = inputs.nixpkgs-neomutt.legacyPackages."${final.system}".neomutt;
}
