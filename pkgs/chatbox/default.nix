{
  appimageTools,
  fetchurl,
}:
let
  pname = "chatbox";
  version = "1.9.5";

  src = fetchurl {
    url = "https://download.chatboxai.app/releases/Chatbox-${version}-x86_64.AppImage";
    hash = "sha256-QmL+imdeHRwJK2iyCh1dr0pBpgvytU4Qi0vpyDDvOP0=";
  };

  appname = "xyz.chatboxapp.app";

  appimageContents = appimageTools.extract {
    inherit pname version src;
    postExtract = ''
      substituteInPlace $out/${appname}.desktop  --replace-fail 'Exec=AppRun' 'Exec=${pname}'
    '';
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    # Desktop File
    install -m 444 -D ${appimageContents}/${appname}.desktop $out/share/applications/${appname}.desktop

    # Icon Files
    for size in 16 24 32 48 64 96 128 256 512 1024; do
      install -D ${appimageContents}/usr/share/icons/hicolor/''${size}x''${size}/apps/${appname}.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/${appname}.png
    done
  '';
}
