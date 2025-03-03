inputs: final: prev:
let
  pkgs = import inputs.nixpkgs-master {
    system = final.system;
    config = {
      allowUnfree = true;
    };
  };
in
{
  epson_201207w = pkgs.epson_201207w;
}
