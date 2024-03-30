{ pkgs, lib, stdenv, ... }:
let
  extraLibraries = pkgs: with pkgs; [
    jdk
    mangohud
  ];

  steamWithExtraLibraries = pkgs.steam.override {
    extraPkgs = extraLibraries;
  };
  dxvkNative = pkgs.callPackage
    ({ stdenv, ... }: stdenv.mkDerivation rec {
      pname = "dxvk-native";
      version = "2.2";
      src = pkgs.fetchurl {
        url = "https://github.com/doitsujin/dxvk/releases/download/v${version}/dxvk-native-${version}-steamrt-sniper.tar.gz";
        sha256 = "sha256-DZrTIUqXa6HgFcyMIyeHXn0vgkdIh42FI/r4WSC594w=";
      };
      sourceRoot = ".";
      buildInputs = [ pkgs.gnutar ];
      buildPhase = ''
    '';
      installPhase = ''
        mkdir -p $out
        cp -r ./lib $out/lib
        cp -r ./lib32 $out/lib32
      '';
    })
    { };
  dxvk2lib = "${dxvkNative}/lib";
  wrapSteam = steam: pkgs.writeScriptBin "steam" ''
    unset SDL_VIDEODRIVER
    unset QT_QPA_PLATFORM
    unset QT_WAYLAND_DISABLE_WINDOWDECORATION
    unset MOZ_ENABLE_WAYLAND
    unset CLUTTER_BACKEND
    unset XDG_SESSION_TYPE

    export NIX_DXVK_D3D9="${dxvk2lib}/libdxvk_d3d9.so"
    export NIX_DXVK_D3D11="${dxvk2lib}/libdxvk_d3d11.so"
    export NIX_DXVK_D3D10CORE="${dxvk2lib}/libdxvk_d3d10core.so"
    export NIX_DXVK_DXGI="${dxvk2lib}/libdxvk_dxgi.so"

    exec ${steam}/bin/steam
  '';
in
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    package = lib.makeOverridable
      (o:
        let overridenSteam = steamWithExtraLibraries.override o;
        in (pkgs.symlinkJoin {
          name = "steam";
          paths = [
            (wrapSteam overridenSteam)
            overridenSteam
          ];
        }).overrideAttrs { run = overridenSteam.run; })
      { };
  };

  hardware.steam-hardware.enable = true;

  programs.java.enable = true;
  programs.gamescope.enable = true;
  programs.gamemode.enable = true;
}

