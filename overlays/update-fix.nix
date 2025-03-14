inputs: final: prev: {
  # https://nixpk.gs/pr-tracker.html?pr=389740
  pwvucontrol = inputs.nixpkgs-master.legacyPackages."${final.system}".pwvucontrol;
}
