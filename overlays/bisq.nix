{ inputs, ... }:
final: prev: {
  bisq-desktop = inputs.nixpkgs-bisq.legacyPackages."${final.system}".bisq-desktop;
}
