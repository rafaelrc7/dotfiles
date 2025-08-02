{
  lib,
  stdenv,
  pkg-config,
}:
stdenv.mkDerivation {
  pname = "hello";
  version = "0.1.0";

  src = lib.cleanSource ./.;

  nativeBuildInputs = [
    pkg-config
  ];

  buildFlags = [
    "release"
  ]
  ++ lib.optionals stdenv.cc.isClang [
    "AR=llvm-ar"
    "RANLIB=llvm-ranlib"
    "NM=llvm-nm"
  ]
  ++ lib.optionals stdenv.cc.isGNU [
    "AR=gcc-ar"
    "RANLIB=gcc-ranlib"
    "NM=gcc-nm"
  ];

  installFlags = [ "prefix=${placeholder "out"}" ];
  enableParallelBuilding = true;
}
