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
  nativeBuildInputs =
    with pkgs;
    [
      jdk
      maven
    ]
    ++ pkgs.lib.optionals devTools [
      gradle # kotlin-language-server dependency
      jdt-language-server
      kotlin-language-server
    ];
}
