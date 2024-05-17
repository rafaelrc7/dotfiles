final: prev: {
  protonmail-bridge = prev.protonmail-bridge.overrideAttrs (old: {
    src = prev.fetchFromGitHub {
      owner = "rafaelrc7";
      repo = "proton-bridge";
      rev = "94c57006d9b5badd5c11bacc24b2cb4b4568ec7d";
      hash = "sha256-XirmFTYj5lagQw4bhc5rXn2/MsUlZvs+bAjmu8x7JJ0=";
    };
  });
}

