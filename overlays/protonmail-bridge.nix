final: prev: {
  protonmail-bridge = prev.protonmail-bridge.overrideAttrs (old: {
    src = prev.fetchFromGitHub {
      owner = "rafaelrc7";
      repo = "proton-bridge";
      rev = "818447d7c7ac6d3c07431d51c8830a201618991a";
      hash = "sha256-PyYTmQ9fq3JgIB31Ao6RXaGCMhl5ytuHMrLObrGwOqs=";
    };
  });
}

