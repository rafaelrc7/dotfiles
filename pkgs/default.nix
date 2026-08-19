{
  pkgs ? import <nixpkgs> { },
}:
let
  cuneifontsPkgs = (pkgs.lib.callPackagesWith pkgs ./cuneifont { });
in
{
  modorganizer2-linux-installer = pkgs.callPackage ./modorganizer2-linux-installer { };
  vim-spell-dict = pkgs.callPackage ./vim-spell { };
  cuneifonts = pkgs.symlinkJoin {
    name = "cuneifonts";
    paths = pkgs.lib.attrValues cuneifontsPkgs;
  };
}
// cuneifontsPkgs
