inputs: final: prev: {
  sdrpp = prev.sdrpp.overrideAttrs (oldAttrs: {
    patches = oldAttrs.patches ++ [ ./server-runtime-prefix.patch ];
    buildInputs = oldAttrs.buildInputs ++ [ final.makeWrapper ];
    postInstall = ''
      wrapProgram $out/bin/sdrpp \
        --set PIPEWIRE_NOJACK 1
    '';
  });
}
