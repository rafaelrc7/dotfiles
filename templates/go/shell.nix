{
  pkgs ? import <nixpkgs> { },
  devTools ? true,
  go ? pkgs.go,
  buildGoModule ? pkgs.buildGoModule.override { inherit go; },
  inputsFrom ? [
    pkgs.callPackage
    ./default.nix
    { inherit buildGoModule; }
  ],
  ...
}:
pkgs.mkShell {
  inherit inputsFrom;
  strictDeps = true;
  nativeBuildInputs = [
    go
  ]
  ++ pkgs.lib.optionals devTools (
    with pkgs;
    [
      gopls
      gotools
      go-tools
      gopkgs
    ]
  );
}
