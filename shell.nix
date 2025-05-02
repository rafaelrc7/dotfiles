{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.mkShell {
  shellHook = ''
    export NH_FLAKE=$(git rev-parse --show-toplevel);
  '';
  nativeBuildInputs = with pkgs; [
    nh
  ];
}
