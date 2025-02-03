{
  appimageTools,
  fetchurl,
  graphicsmagick,
}:
let
  pname = "lmstudio";
  version = "0.3.9-6";

  src = fetchurl {
    url = "https://installers.lmstudio.ai/linux/x64/${version}/LM-Studio-${version}-x64.AppImage";
    hash = "sha256-L3wYMqyjUL5pTz+/ujn76YYIfWzjqa3eoyNblU8/5hs=";
  };

  appname = "lm-studio";

  appimageContents = appimageTools.extract {
    inherit pname version src;
    postExtract = ''
      substituteInPlace $out/${appname}.desktop --replace-fail 'Exec=AppRun' 'Exec=${pname}'
    '';
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  nativeBuildInputs = [
    graphicsmagick
  ];

  extraInstallCommands = ''
    # Desktop File
    install -m 444 -D ${appimageContents}/${appname}.desktop $out/share/applications/${appname}.desktop

    # Icon Files
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/0x0/apps/${appname}.png \
      $out/share/icons/hicolor/0x0/apps/${appname}.png
    for size in 16 32 48 64 96 128 256 512; do
      gm convert ${appimageContents}/usr/share/icons/hicolor/0x0/apps/${appname}.png -resize ''${size}x''${size} icon_$size.png
      install -D icon_$size.png $out/share/icons/hicolor/''${size}x''${size}/apps/${appname}.png
    done
  '';
}
