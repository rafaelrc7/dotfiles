{ lib
, stdenv
, neovim
, hunspellDicts
}:
stdenv.mkDerivation {
  pname = "vim-spell-dict";
  version = "1.0.0";

  dontUnpack = true;
  dontPatch = true;
  dontConfigure = true;

  nativeBuildInputs = [
    neovim
    hunspellDicts.en-us
    hunspellDicts.en-gb-ise
    hunspellDicts.pt-br
  ];

  buildPhase = ''
    runHook preBuild

    cp ${hunspellDicts.en-gb-ise}/share/hunspell/* .
    cp ${hunspellDicts.en-us}/share/hunspell/* .
    cp ${hunspellDicts.pt-br}/share/hunspell/* .

    nvim -es -n --clean -c "mkspell! en en_GB en_US"
    nvim -es -n --clean -c "mkspell! pt pt_BR"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/spell
    find . -type f -name "*.utf-8.spl" -maxdepth 1 -exec \
      install -Dm444 "{}" -t $out/share/spell \;

    runHook postInstall
  '';

  meta = with lib; {
    maintainers = [ rafaelrc ];
  };
}

