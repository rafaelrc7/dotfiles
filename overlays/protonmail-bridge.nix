{ inputs, ... }:
final: prev: {
  protonmail-bridge = prev.protonmail-bridge.overrideAttrs (old: {
    src = inputs.proton-bridge;
  });
}

