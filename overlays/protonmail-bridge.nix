{ inputs, ... }:
final: prev: {
  protonmail-bridge = prev.protonmail-bridge.overrideAttrs (old: {
    version = "3.14.0";
    src = inputs.proton-bridge;
    vendorHash = "sha256-I/OFpEa3aB+qDBS/sbX5WOgrlSyR7aZaQYrsaSVNAAk=";
  });
}

