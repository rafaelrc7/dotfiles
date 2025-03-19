inputs: final: prev: {
  protonmail-bridge = prev.protonmail-bridge.overrideAttrs (attrs: {
    patches = [
      ./remove-pass.patch
    ];
  });
}
