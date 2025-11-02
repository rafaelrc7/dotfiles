inputs: final: prev:
let
  bisqPkgs = inputs.bisq-for-nixos.packages."${final.stdenv.hostPlatform.system}";
in
{
  bisq-desktop = bisqPkgs.bisq-desktop-appimage-wrapper.override {
    bisqAppImage = bisqPkgs.bisq-desktop-appimage;
  };
}
