{ pkgs ? import <nixpkgs> { } }: rec {
  modorganizer2-linux-installer = pkgs.callPackage ./modorganizer2-linux-installer { };
}

