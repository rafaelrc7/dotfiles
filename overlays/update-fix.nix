inputs: final: prev: {
  luajitPackages = inputs.nixpkgs-prev.packages."${final.system}".luajitPackages;
}
