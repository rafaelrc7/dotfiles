{ pkgs, ... }:
{
  imports = [
    ./gamescope.nix
  ];

  programs.steam = {
    enable = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    remotePlay.openFirewall = true;
    extest.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    protontricks.enable = true;
    package = pkgs.steam.override {
      extraPkgs = p: with p; [
        glxinfo
        jdk
        mangohud
      ];
      extraLibraries = p: with p; [
        gperftools
        harfbuzz
        libthai
        pango
      ];
      extraEnv = {
        SDL_VIDEODRIVER = "";
        QT_QPA_PLATFORM = "";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "";
        XDG_SESSION_TYPE = "";

        MANGOHUD = true;
      };
    };
  };

  hardware.steam-hardware.enable = true;

  programs.java.enable = true;
  programs.gamemode.enable = true;
}

