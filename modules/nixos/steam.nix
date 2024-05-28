{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    package = pkgs.steam.override {
      extraPkgs = p: with p; [
        jdk
        mangohud
      ];
      extraLibraries = p: [

      ];
      extraEnv = {
        SDL_VIDEODRIVER = "";
        QT_QPA_PLATFORM = "";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "";
        MOZ_ENABLE_WAYLAND = "";
        CLUTTER_BACKEND = "";
        XDG_SESSION_TYPE = "";

        MANGOHUD = true;
      };
    };
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  hardware.steam-hardware.enable = true;

  programs.java.enable = true;
  programs.gamescope.enable = true;
  programs.gamemode.enable = true;
}

