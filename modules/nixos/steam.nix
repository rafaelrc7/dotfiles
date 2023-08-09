{ pkgs, lib, ... }: let
  extraLibraries = pkgs: with pkgs; [
    jdk
  ];

  steamWithExtraLibraries = pkgs.steam.override {
    extraPkgs = extraLibraries;
  };
  wrapSteam = steam: pkgs.writeScriptBin "steam" ''
    unset SDL_VIDEODRIVER
    unset QT_QPA_PLATFORM
    unset QT_WAYLAND_DISABLE_WINDOWDECORATION
    unset MOZ_ENABLE_WAYLAND
    unset CLUTTER_BACKEND
    unset XDG_SESSION_TYPE

    exec ${steam}/bin/steam
  '';
in {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    package = lib.makeOverridable (o:
      let overridenSteam = steamWithExtraLibraries.override o;
      in (pkgs.symlinkJoin {
        name = "steam";
        paths = [
          (wrapSteam overridenSteam)
          overridenSteam
        ];
      }).overrideAttrs { run = overridenSteam.run; }) { };
  };

  hardware.steam-hardware.enable = true;
  programs.java.enable = true;
}

