inputs: final: prev: {
  protonmail-bridge = prev.protonmail-bridge.overrideAttrs (old: {
    version = "3.18.0";
    src = inputs.proton-bridge;
    vendorHash = "sha256-S08Vw/dLLVd6zFWmpG8wDVf7LOdSC29qo7pUscYHDyY=";
  });
}
