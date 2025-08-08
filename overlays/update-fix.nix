inputs: final: prev: {
  luajitPackages = prev.luajitPackages.overrideScope (
    lfinal: lprev: {
      neotest = inputs.nixpkgs-prev.packages."${final.system}".luajitPackages.neotest;
    }
  );
}
