{ ... }:
final: prev: {
  sdrpp = final.symlinkJoin {
    pname = prev.sdrpp.pname;
    version = prev.sdrpp.version;
    paths = [ prev.sdrpp ];
    buildInputs = [ final.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/sdrpp \
        --set PIPEWIRE_NOJACK 1
    '';
  };
}
