inputs: final: prev: {
  sdrpp = final.symlinkJoin {
    pname = prev.sdrpp.pname;
    version = prev.sdrpp.version;
    paths = [ prev.sdrpp ];
    buildInputs = [ final.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/sdrpp \
        --set PIPEWIRE_NOJACK 1
      rm "$out/share/applications/sdrpp.desktop"
      substitute "${prev.sdrpp}/share/applications/sdrpp.desktop" \
        "''${out}/share/applications/sdrpp.desktop" \
        --replace "${prev.sdrpp}" "$out"
    '';
  };
}
