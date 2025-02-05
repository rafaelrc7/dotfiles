{
  name,
  lib,
  stdenv,
  tex,
}:
stdenv.mkDerivation rec {
  inherit name;
  src = lib.cleanSource ./.;
  nativeBuildInputs = [ tex ];
  buildPhase = ''
    mkdir -p .cache/latex
    latexmk -interaction=nonstopmode -auxdir=.cache/latex -pdf ${name}.tex
  '';
  installPhase = ''
    mkdir -p $out
    cp ${name}.pdf $out
  '';
}
