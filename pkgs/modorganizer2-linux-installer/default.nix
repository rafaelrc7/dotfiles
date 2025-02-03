{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  p7zip,
  protontricks,
  wget,
  zenity,
}:
stdenv.mkDerivation rec {
  pname = "modorganizer2-linux-installer";
  version = "5.0.3";

  src = fetchurl {
    url = "https://github.com/rockerbacon/modorganizer2-linux-installer/releases/download/${version}/mo2installer-${version}.tar.gz";
    sha256 = "sha256-C79xZvnAc4hJ0Io32JVye9HBecNtZByd7eJIH+z/uV4=";
  };

  sourceRoot = ".";

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/${pname}
    cp -r . $out/opt/${pname}
    chmod +x $out/opt/${pname}/install.sh

    makeWrapper $out/opt/${pname}/install.sh $out/bin/${pname} \
      --prefix PATH ":" ${
        lib.makeBinPath [
          zenity
          p7zip
          protontricks
          wget
        ]
      } \
      --chdir "$out/opt/${pname}"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/rockerbacon/modorganizer2-linux-installer";
    description = "An easy-to-use Mod Organizer 2 installer for Linux";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ rafaelrc ];
  };
}
