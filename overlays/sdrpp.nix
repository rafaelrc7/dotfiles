inputs: final: prev: {
  sdrpp = prev.sdrpp.overrideAttrs (oldAttrs: {
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ final.makeWrapper ];
    postInstall = ''
      wrapProgram $out/bin/sdrpp \
        --set PIPEWIRE_NOJACK 1
    '';
  });
}
