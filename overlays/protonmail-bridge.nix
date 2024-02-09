final: prev: {
  protonmail-bridge = prev.protonmail-bridge.overrideAttrs (old: {
    src = prev.fetchFromGitHub {
      owner = "rafaelrc7";
      repo = "proton-bridge";
      rev = "d8d345258b2e9d4b75a55bb03a444a35ad3d724d";
      hash = "sha256-wrmksI2LzTywCIRxu4sZ5G9EsEHDq7TcoODY7ySQnPA=";
    };
  });
}

