{ inputs, ... }:
final: prev:
let nixpkgs-prev = import inputs.nixpkgs-prev { system = final.system; config = { allowUnfree = true; }; };
in
{
  epson-escpr = nixpkgs-prev.epson-escpr;
  epson_201207w = nixpkgs-prev.epson_201207w;
  jami = nixpkgs-prev.jami;
}

