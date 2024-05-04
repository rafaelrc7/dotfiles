{ lib
, stdenv
, fetchurl
, makeWrapper
, gnome
, p7zip
, protontricks
, wget
}:
stdenv.mkDerivation rec {
  pname = "modorganizer2-linux-installer";
  version = "4.6.1";

  src = fetchurl {
    url = "https://github.com/rockerbacon/modorganizer2-linux-installer/releases/download/${version}/mo2installer-${version}.tar.gz";
    sha256 = "sha256-17nZA4vP791Q3Mky5mViEvBbibE04eBdrR7G5D269vI=";
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
      --prefix PATH ":" ${lib.makeBinPath [ gnome.zenity p7zip protontricks wget ]} \
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

