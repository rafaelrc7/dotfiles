{
  autoreconfHook,
  lib,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "hello";
  version = "0.1.0";
  src = lib.cleanSource ./.;
  nativeBuildInputs = [ autoreconfHook ];
}
