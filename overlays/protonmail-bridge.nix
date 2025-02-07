inputs: final: prev: {
  protonmail-bridge = prev.protonmail-bridge.overrideAttrs (old: {
    version = "3.16.0";
    src = inputs.proton-bridge;
    vendorHash = "sha256-RKAkdCTkUcUKO+eXvn/Sh52Un4DzvgUlF19MiGm/K0c=";
  });
}
