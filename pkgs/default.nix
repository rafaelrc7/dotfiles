{
  pkgs ? import <nixpkgs> { },
}:
{
  krisp-patcher = pkgs.callPackage ./krisp-patcher { };
  modorganizer2-linux-installer = pkgs.callPackage ./modorganizer2-linux-installer { };
  vim-spell-dict = pkgs.callPackage ./vim-spell { };
  chatbox = pkgs.callPackage ./chatbox { };
  lmstudio = pkgs.callPackage ./lmstudio { };
}
