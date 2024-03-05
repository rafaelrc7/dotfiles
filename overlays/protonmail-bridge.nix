final: prev: {
  protonmail-bridge = prev.protonmail-bridge.overrideAttrs (old: {
    src = prev.fetchFromGitHub {
      owner = "rafaelrc7";
      repo = "proton-bridge";
      rev = "513df54df13a7bf92055cc284802ee5af23b34fe";
      hash = "sha256-zWNS1YvrktvA4vBBLXToDed/eCbvXillVJmKv9nVXV4=";
    };
  });
}

