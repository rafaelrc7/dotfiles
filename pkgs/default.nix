{ pkgs ? import <nixpkgs> { } }: {
  modorganizer2-linux-installer = pkgs.callPackage ./modorganizer2-linux-installer { };
  vim-spell-dict = pkgs.callPackage ./vim-spell { };
}

