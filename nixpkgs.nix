# https://github.com/Misterio77/nix-starter-configs/blob/0537107ce41396dff1fb1dd43705a94e9120f576/standard/nixpkgs.nix

# A nixpkgs instance that is grabbed from the pinned nixpkgs commit in the lock file
# This is useful to avoid using channels when using legacy nix commands
let
  lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
in
args:
import (fetchTarball {
  url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
  sha256 = lock.narHash;
}) args
