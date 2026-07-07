{
  lib,
  stdenvNoCC,
  fetchurl,
  fetchzip,
}:
let
  baseURL = "https://smaw.de.dariah.eu/cuneifont/download";
  buildArchiveURL = timestamp: file: "https://web.archive.org/web/${timestamp}/${baseURL}/${file}";

  fetchttf =
    { url, hash }:
    fetchurl {
      inherit url hash;
      downloadToTemp = true;
      recursiveHash = true;
      postFetch = "install -D $downloadedFile $out/" + baseNameOf url;
    };

  fonts = {
    santakku = {
      version = "0-unstable-2026-07-07";
      src = fetchzip {
        url = buildArchiveURL "20260707205635" "Santakku.zip";
        hash = "sha256-eBmZT0rn6sew76Qgs+nOWJHQHehRcepLjeQDzS0gzqc=";
        stripRoot = false;
      };
      phases = [
        "unpackPhase"
        "installPhase"
      ];
      description = "Old Babylonian cuneiform font";
    };

    ullikummi = {
      version = "0-unstable-2026-07-07";
      src = fetchzip {
        url = buildArchiveURL "20260707205659" "Ullikummi.zip";
        hash = "sha256-RdJ/UgOXLfBNsNMnWVsJqcNgOeOTdcCs+GrEyB6qvkg=";
        stripRoot = false;
      };
      phases = [
        "unpackPhase"
        "installPhase"
      ];
      description = "Hittite cuneiform font";
    };

    assurbanipal = {
      version = "0-unstable-2026-07-07";
      src = fetchttf {
        url = buildArchiveURL "20260707205121" "Assurbanipal.ttf";
        hash = "sha256-lpmYMpdgxrbRzZrRzF0MwfBhOtCeFwlqH3pJ+jRTU2I=";
      };
      phases = [
        "installPhase"
      ];
      description = "Neo-Assyrian cuneiform font";
    };

    esagil = {
      version = "0-unstable-2026-07-07";
      src = fetchttf {
        url = buildArchiveURL "20260707205726" "Esagil.ttf";
        hash = "sha256-gbITTl+B+CMsyH+6gw6KpnNIb2h7nK02LuBq9I/WOLo=";
      };
      phases = [
        "installPhase"
      ];
      description = "Neo-Babylonian cuneiform font";
    };

    oldPersian = {
      version = "0-unstable-2026-07-07";
      src = fetchzip {
        url = buildArchiveURL "20260707205748" "OldPersian.zip";
        hash = "sha256-0VlejElgsm/xDIFqF7LiQ/dOfTytDpXhFBOlo45wBw0=";
        stripRoot = false;
      };
      phases = [
        "unpackPhase"
        "installPhase"
      ];
      description = "Old Persian cuneiform font";
    };

  };

  mkFontPkg =
    pname:
    {
      version,
      src,
      description,
      phases,
    }:
    stdenvNoCC.mkDerivation (attrs: {
      inherit
        pname
        version
        src
        phases
        ;

      installPhase = ''
        runHook preInstall

        install -Dm644 ${attrs.src}/*.ttf -t "$out/share/fonts/truetype"

        runHook postInstall
      '';

      meta = {
        inherit description;
        homepage = "https://web.archive.org/web/20260705152745/https://smaw.de.dariah.eu/cuneifont/";
        license = lib.licenses.unfree; # I don't know
      };
    });
in
lib.mapAttrs mkFontPkg fonts
