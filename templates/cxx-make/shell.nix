{
  pkgs ? import <nixpkgs> { },
  devTools ? true,
  inputsFrom ? [
    pkgs.callPackage
    ./default.nix
    { }
  ],
  ...
}:
pkgs.mkShell {
  inherit inputsFrom;
  strictDeps = true;
  hardeningDisable = [ "all" ];
  nativeBuildInputs =
    with pkgs;
    [ ]
    ++ pkgs.lib.optionals devTools [
      bear
      clang-tools
      gdb
      libclang
      valgrind
    ];
}
