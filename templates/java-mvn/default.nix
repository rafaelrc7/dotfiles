{
  lib,
  jre,
  makeWrapper,
  maven,
}:

maven.buildMavenPackage rec {
  pname = "hello";
  version = "0.1.0";

  src = lib.cleanSource ./.;

  # Maven uses the internet for downloading deps, thus you need to manually
  # update the mvnHash when they change. You can set it to `lib.fakeHash` and
  # get the right one from the error message
  mvnHash = "sha256-dl4kf2WeJ68q3TcY8YgYmmd51ScHbSPhlKn6NfJ0rXo=";

  mvnParameters = lib.escapeShellArgs [
    "-Dspotless.check.skip"
    "-Dspotless.apply.skip"
  ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/share/${pname}
    install -Dm644 ./target/${pname}-${version}-jar-with-dependencies.jar $out/share/${pname}

    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --add-flags "-jar $out/share/${pname}/${pname}-${version}-jar-with-dependencies.jar"
  '';
}
