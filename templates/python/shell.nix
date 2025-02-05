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
      python3
    ]
    ++ pkgs.lib.optional devTools [
      pyright
    ];
}
