{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.mkShell {
  shellHook = ''
    export FLAKE=$(git rev-parse --show-toplevel);
  '';
  nativeBuildInputs = with pkgs; [
    nh
  ];
}
