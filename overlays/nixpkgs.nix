inputs: final: prev:
let
  system = final.stdenv.hostPlatform.system;
  config = {
    allowUnfree = true;
  };
in
{
  nixpkgs-stable = import inputs.nixpkgs-stable { inherit system config; };
  nixpkgs-unstable = import inputs.nixpkgs-unstable { inherit system config; };
  nixpkgs-master = import inputs.nixpkgs-master { inherit system config; };
}
