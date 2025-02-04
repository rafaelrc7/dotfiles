{ lib, stdenv }:
stdenv.mkDerivation {
  pname = "hello";
  version = "0.1.0";

  src = lib.cleanSource ./.;

  buildPhase = ''
    make release
  '';

  installPhase = ''
    mkdir -p $out
    PREFIX=$out make install
  '';
}
