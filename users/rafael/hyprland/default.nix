{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  isNixOS = osConfig != null;
in
{
  imports = [
    ../waybar.nix
    ../wayland.nix
    ./hyprsunset
  ];

  home.packages = with pkgs; [
    hypridle
    hyprland
    hyprland-guiutils
    hyprlock
    hyprpaper
    libsForQt5.qt5.qtwayland
    qt6.qtwayland

    brightnessctl
    cliphist
    findutils
    fuzzel
    gpu-screen-recorder-gtk
    jq
    killall
    mako
    playerctl
    qalculate-qt
    wlogout
  ];

  xdg.configFile."uwsm/env".text = ''
    export XDG_SESSION_TYPE=wayland

    export CLUTTER_BACKEND=wayland
    export GDK_BACKEND=wayland,x11,*
    export QT_QPA_PLATFORM=wayland;xcb
    export SDL_VIDEODRIVER=wayland

    export _JAVA_AWT_WM_NONREPARENTING=1
    export MOZ_ENABLE_WAYLAND=1
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

    export LIBVA_DRIVER_NAME=nvidia
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
  '';

  xdg.configFile."uwsm/env-hyprland".text = ''
    export XDG_CURRENT_DESKTOP=Hyprland
    export XDG_SESSION_DESKTOP=Hyprland
  '';

  xdg.configFile."hypr/hyprlandrc" = {
    recursive = true;
    source = ./lua/hyprlandrc;
  };

  wayland.windowManager.hyprland = {
    enable = true;

    package = pkgs.hyprland;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;

    xwayland.enable = true;

    configType = "lua";
    extraConfig = builtins.readFile ./lua/hyprland.lua;
  };

  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];

  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      wallpaper =
        (lib.optional isNixOS {
          fit_mode = "cover";
          path = "${../imgs/wallpapers/${osConfig.networking.hostName}}";
          monitor = "";
        })
        ++ [

        ];
    };
  };

  systemd.user.services.hyprpaper.Install.WantedBy = [ config.wayland.systemd.target ];

  systemd.user.services.hyprpaper-load = lib.mkIf (!isNixOS) (
    let
      loadWallpaper = pkgs.writeShellScriptBin "loadWallpaper" ''
        set -eo pipefail
        [[ -f ${config.xdg.userDirs.pictures}/Wallpapers/default ]] && WALLPAPER="${config.xdg.userDirs.pictures}/Wallpapers/default"
        [[ -f ${config.xdg.userDirs.pictures}/Wallpapers/`uname -n` ]] && WALLPAPER="${config.xdg.userDirs.pictures}/Wallpapers/`uname -n`"
        [[ -f ${config.xdg.configHome}/wallpaper ]] && WALLPAPER="${config.xdg.configHome}/wallpaper"
        [[ -v WALLPAPER ]] && exec -- ${pkgs.hyprland}/bin/hyprctl hyprpaper wallpaper ,"$WALLPAPER"
        exit 0
      '';
    in
    {
      Unit = {
        Description = "Hyprpaper wallpaper utility for Hyprland";
        After = "hyprpaper.service";
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${loadWallpaper}/bin/loadWallpaper";
        Restart = "on-failure";
        Slice = "background-graphical.slice";
      };

      Install.WantedBy = [ "hyprpaper.service" ];
    }
  );

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "${pkgs.procps}/bin/pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock --grace 0";
        unlock_cmd = "${pkgs.procps}/bin/pkill -USR1 hyprlock";
        before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
        after_sleep_cmd = ''${pkgs.hyprland}/bin/hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })'';
        ignore_dbus_inhibit = false;
        ignore_systemd_inhibit = false;
      };

      listener = [
        {
          timeout = 300; # 5m
          on-timeout = "${pkgs.hyprlock}/bin/hyprlock --grace 30";
        }
        {
          timeout = 330; # 5.5m
          on-timeout = ''${pkgs.hyprland}/bin/hyprctl hyprctl dispatch 'hl.dsp.dpms({ action = "disable" })'';
          on-resume = ''${pkgs.hyprland}/bin/hyprctl hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })'';
        }
      ];
    };
  };

  systemd.user.services.hypridle = rec {
    Service.Slice = "background.slice";
    Unit.After = Install.WantedBy;
    Install.WantedBy = lib.mkForce [ config.wayland.systemd.target ];
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        text_trim = true;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];
    };
  };
}
