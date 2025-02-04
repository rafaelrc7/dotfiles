{
  lib,
  haskell,
  haskellPackages,
}:
lib.pipe (haskellPackages.callCabal2nix "hello" (lib.cleanSource ./.) { }) (
  with haskell.lib.compose; [ dontHaddock ]
)
