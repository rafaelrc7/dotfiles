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
    [
      autoconf
      automake
      gcc
      gettext
      libtool
      pkg-config
    ]
    ++ pkgs.lib.optional devTools [
      autotools-language-server
      bear
      clang-tools
      gdb
      valgrind
    ];
}
