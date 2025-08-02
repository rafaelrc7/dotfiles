{
  inputs,
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  inherit (lib) optionals;
  isNixOS = osConfig != null;
  isNixOSHyprland = isNixOS && osConfig.programs.hyprland.enable;
  isUWSM = isNixOSHyprland && osConfig.programs.hyprland.withUWSM;
  execCmd = if isUWSM then "uwsm app -- " else "";
in
{
  imports = [
    ./waybar.nix
    ./wayland.nix
    ./hyprsunset.nix
  ];

  home.packages = with pkgs; [
    hyprland
    hypridle
    hyprlock
    hyprpaper
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
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
  '';

  xdg.configFile."uwsm/env-hyprland".text = ''
    export XDG_CURRENT_DESKTOP=Hyprland
    export XDG_SESSION_DESKTOP=Hyprland
  '';

  wayland.windowManager.hyprland =
    let
      menu = ''${pkgs.fuzzel}/bin/fuzzel --hide-before-typing --launch-prefix="${execCmd}"'';
      terminal = "${pkgs.kitty}/bin/kitty";
      browser = "${config.programs.firefox.finalPackage}/bin/firefox";
      fileManager = "${pkgs.kdePackages.dolphin}/bin/dolphin";
      printClip = "${pkgs.flameshot}/bin/flameshot gui";
      calculator = "${pkgs.qalculate-qt}/bin/qalculate-qt";
    in
    {
      enable = true;

      systemd = {
        enable = !isUWSM;
        enableXdgAutostart = true;
        variables = [
          "DISPLAY"
          "WAYLAND_DISPLAY"
          "HYPRLAND_INSTANCE_SIGNATURE"
          "XDG_CURRENT_DESKTOP"
          "XDG_SESSION_TYPE"
          "NIXOS_OZONE_WL"
          "XCURSOR_THEME"
          "XCURSOR_SIZE"
          "QT_QPA_PLATFORMTHEME"
          "QT_QPA_PLATFORM"
          "QT_PLUGIN_PATH"
          "QT_STYLE_OVERRIDE"
          "SDL_VIDEODRIVER"
          "_JAVA_AWT_WM_NONREPARENTING"
          "PATH"
        ];

        extraCommands = [
          "${pkgs.systemd}/bin/systemctl --user stop hyprland-session.target"
          "${pkgs.systemd}/bin/systemctl --user reset-failed"
          "${pkgs.systemd}/bin/systemctl --user start hyprland-session.target"
        ];
      };

      xwayland.enable = true;

      importantPrefixes = [ ];

      settings = {
        monitor = [
          "desc:LG Electronics LG ULTRAWIDE 0x01010101, preferred, 0x0,    1"
          "desc:LG Electronics LG FULL HD 0x01010101,   preferred, 2560x0, 1"
          ",                                            preferred, auto,   1"
        ];

        workspace = [
          "10, monitor:desc:LG Electronics LG FULL HD 0x01010101, default:true"
          "special:scratchpad,    on-created-empty:${execCmd}${terminal}"
          "special:calculator,    on-created-empty:${execCmd}${calculator}"
          "special:screen-record, on-created-empty:${execCmd}${pkgs.gpu-screen-recorder-gtk}/bin/gpu-screen-recorder-gtk"
        ];

        windowrulev2 = [
          # No borders when only tiled window. Keep border on maximised
          "bordersize 0, floating:0, onworkspace:w[tv1]"
          "rounding 0,   floating:0, onworkspace:w[tv1]"

          # Floating Steam dialogs
          "float, class:steam"
          "tile,  class:steam, title:Friends List"
          "tile,  class:steam, title:Steam"

          # No borders on steam games
          "bordersize 0, class:(steam_app.*)"
          "rounding 0,   class:(steam_app.*)"
          "stayfocused,  class:(steam_app.*)"

          # Floating Paradox Launchers
          "float,              class:(Paradox Launcher)"
          "center, floating:1, class:(Paradox Launcher)"

          # Floating Picture-in-Picture
          "float, class:(firefox), title:(Picture-in-Picture)"

          # Fix flameshot on multiple monitors
          "pin,                      class:(flameshot), title:(flameshot)"
          "stayfocused,              class:(flameshot), title:(flameshot)"
          "suppressevent fullscreen, class:(flameshot), title:(flameshot)"
          "float,                    class:(flameshot), title:(flameshot)"
          "monitor 0,                class:(flameshot), title:(flameshot)"
          "move 0 0,                 class:(flameshot), title:(flameshot)"
          "bordersize 0,             class:(flameshot), title:(flameshot)"
          "rounding 0,               class:(flameshot), title:(flameshot)"

          # Fix password dialogs losing focus
          "stayfocused, class:(pinentry-)(.*)"
          "stayfocused, class:(polkit-)(.*), title:(Authenticate)"
          "stayfocused, class:(gcr-prompter)"

          # Hide password dialogs
          "noscreenshare, class:(pinentry-)(.*)"
          "noscreenshare, class:(polkit-)(.*), title:(Authenticate)"
          "noscreenshare, class:(gcr-prompter)"

          # Make qalculate-qt floating by default
          "float, class:^(io.github.Qalculate.qalculate-qt)$"

          # Move spotify to special workspace
          "workspace special:music, class:spotify"

          # Make special workspaces floating
          "float, onworkspace:n[s:special:scratchpad]"
          "float, onworkspace:n[s:special:calculator]"
          "float, onworkspace:n[s:special:screen-record]"
        ];

        "$mod" = "SUPER";

        exec-once = map (cmd: execCmd + cmd) [
        ];

        bind = [
          # Apps
          "$mod, RETURN, exec, ${execCmd}${terminal}"
          "$mod, D, exec, ${execCmd}${menu}"
          "$mod, Q, exec, ${execCmd}${browser}"
          "$mod, E, exec, ${execCmd}${fileManager}"

          # Screenshot
          ", Print, exec, ${execCmd}${printClip}"

          # Save replay
          "$mod + SHIFT, R, exec, ${execCmd}${pkgs.killall}/bin/killall -s SIGUSR1 gpu-screen-recorder"

          # Clear notifications
          "$mod + CTRL, SPACE, exec, ${execCmd}${pkgs.mako}/bin/makoctl dismiss -a"

          # Toggle waybar
          "$mod, B, exec, ${execCmd}${pkgs.killall}/bin/killall -s SIGUSR1 -r waybar"

          # Fullscreen / maximise
          "$mod, F, fullscreen, 0"
          "$mod, M, fullscreen, 1"
          "$mod + SHIFT, F, fullscreen, 2"

          # Close active
          "$mod + SHIFT, Q, killactive"

          # Kill mode
          "$mod + CTRL, Q, exec, ${execCmd}${pkgs.hyprland}/bin/hyprctl kill"

          # Sticky
          "$mod + SHIFT, S, pin"

          # Toggle floating
          "$mod + SHIFT, SPACE, togglefloating"

          # Exit/logout
          "$mod + SHIFT, E, exec, ${execCmd}${pkgs.wlogout}/bin/wlogout"
          "$mod + CTRL, L, exec, ${execCmd}${pkgs.systemd}/bin/loginctl lock-session"

          # Clipboard manager
          "$mod, P, exec, ${execCmd}${pkgs.cliphist}/bin/cliphist list | ${pkgs.fuzzel}/bin/fuzzel -p \"Copy\" --dmenu | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy"
          "$mod + SHIFT, P, exec, ${execCmd}${pkgs.cliphist}/bin/cliphist list | ${pkgs.fuzzel}/bin/fuzzel -p \"Delete from history\" --dmenu | ${pkgs.cliphist}/bin/cliphist delete"
          "$mod + ALT, P, exec, ${execCmd}${pkgs.cliphist}/bin/cliphist wipe"

          # Brightness
          ", XF86MonBrightnessUp, exec, ${execCmd}${pkgs.brightnessctl}/bin/brightnessctl set 10%+"
          ", XF86MonBrightnessDown, exec, ${execCmd}${pkgs.brightnessctl}/bin/brightnessctl set 10%-"

          # Audio
          "SHIFT, XF86AudioMute, exec, ${execCmd}${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

          # Global binds
          "ALT, Pause, pass, class:(discord)"

          # Tab windows
          "$mod, T, togglegroup"

          # Dwindle
          "$mod, O, pseudo,"
          "$mod, S, togglesplit"
          "$mod + SHIFT + ALT, H, layoutmsg, preselect l"
          "$mod + SHIFT + ALT, J, layoutmsg, preselect d"
          "$mod + SHIFT + ALT, K, layoutmsg, preselect u"
          "$mod + SHIFT + ALT, L, layoutmsg, preselect r"

          # Focus inside tabgroup
          "$mod + ALT, H, changegroupactive, b"
          "$mod + ALT, L, changegroupactive, f"

          # Focus between windows
          "$mod, H, movefocus, l"
          "$mod, J, movefocus, d"
          "$mod, K, movefocus, u"
          "$mod, L, movefocus, r"

          # Move window
          "$mod + SHIFT, H, movewindoworgroup, l"
          "$mod + SHIFT, J, movewindoworgroup, d"
          "$mod + SHIFT, K, movewindoworgroup, u"
          "$mod + SHIFT, L, movewindoworgroup, r"

          # Change workspace
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod, 0, workspace, 10"
          "$mod + ALT, M, togglespecialworkspace, music"
          "$mod, minus, togglespecialworkspace, scratchpad"
          "$mod, C,     togglespecialworkspace, calculator"
          "$mod, R,     togglespecialworkspace, screen-record"
          "$mod, equal, exec, ${execCmd}${pkgs.hyprland}/bin/hyprctl workspaces -j | ${pkgs.jq}/bin/jq -r '.[] | .name' | ${pkgs.fuzzel}/bin/fuzzel --dmenu | ${pkgs.findutils}/bin/xargs -I {} ${pkgs.hyprland}/bin/hyprctl dispatch workspace name:{}"

          # Move window between workspaces
          "$mod + SHIFT, 1, movetoworkspacesilent, 1"
          "$mod + SHIFT, 2, movetoworkspacesilent, 2"
          "$mod + SHIFT, 3, movetoworkspacesilent, 3"
          "$mod + SHIFT, 4, movetoworkspacesilent, 4"
          "$mod + SHIFT, 5, movetoworkspacesilent, 5"
          "$mod + SHIFT, 6, movetoworkspacesilent, 6"
          "$mod + SHIFT, 7, movetoworkspacesilent, 7"
          "$mod + SHIFT, 8, movetoworkspacesilent, 8"
          "$mod + SHIFT, 9, movetoworkspacesilent, 9"
          "$mod + SHIFT, 0, movetoworkspacesilent, 10"
          "$mod + SHIFT, minus, movetoworkspacesilent, special:scratchpad"
          "$mod + SHIFT, equal, exec, ${execCmd}${pkgs.hyprland}/bin/hyprctl workspaces -j | ${pkgs.jq}/bin/jq -r '.[] | .name' | ${pkgs.fuzzel}/bin/fuzzel --dmenu | ${pkgs.findutils}/bin/xargs -I {} ${pkgs.hyprland}/bin/hyprctl dispatch movetoworkspacesilent name:{}"
        ];

        bindel = [
          # Global Volume
          ", XF86AudioRaiseVolume, exec, ${execCmd}${pkgs.wireplumber}/bin/wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, ${execCmd}${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"

          # App Volume
          "ALT, XF86AudioRaiseVolume, exec, ${execCmd}${pkgs.playerctl}/bin/playerctl volume 0.1+"
          "ALT, XF86AudioLowerVolume, exec, ${execCmd}${pkgs.playerctl}/bin/playerctl volume 0.1-"
        ];

        bindl = [
          # Mute
          ", XF86AudioMute, exec, ${execCmd}${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

          # Media keys
          ", XF86AudioPlay, exec, ${execCmd}${pkgs.playerctl}/bin/playerctl play-pause"
          ", XF86AudioStop, exec, ${execCmd}${pkgs.playerctl}/bin/playerctl stop"
          ", XF86AudioPrev, exec, ${execCmd}${pkgs.playerctl}/bin/playerctl previous"
          ", XF86AudioNext, exec, ${execCmd}${pkgs.playerctl}/bin/playerctl next"

          "SHIFT, XF86AudioPrev, exec, ${execCmd}${pkgs.playerctl}/bin/playerctl position 10-"
          "SHIFT, XF86AudioNext, exec, ${execCmd}${pkgs.playerctl}/bin/playerctl position 10+"
        ];

        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow 2"
          "$mod + SHIFT, mouse:273, resizewindow 1" # resize keeping aspect ratio
        ];

        general = {
          layout = "dwindle";

          gaps_in = 4;
          gaps_out = 0;
          border_size = 2;
          no_border_on_floating = false;

          resize_on_border = true;
          hover_icon_on_border = true;
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        master = {
          new_status = "master";
        };

        decoration = {
          rounding = 5;

          dim_special = 0.5;

          active_opacity = 1.0;
          inactive_opacity = 1.0;
          fullscreen_opacity = 1.0;

          dim_inactive = false;

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            offset = "0 0";
            scale = "1.0";
          };

          blur = {
            enabled = true;
            size = 8;
            passes = 1;
            ignore_opacity = false;
            new_optimizations = true;
            popups = false;
          };
        };

        animations = {
          enabled = true;
          first_launch_animation = true;
          # TODO: animations
        };

        input = {
          kb_layout = "us,br";
          kb_model = ",abnt2";
          kb_variant = "intl,abnt2";
          kb_options = "compose:rctrl";

          numlock_by_default = true;
          resolve_binds_by_sym = true;

          follow_mouse = 1;

          touchpad = {
            disable_while_typing = true;
            middle_button_emulation = true;
            clickfinger_behavior = true;
            tap-to-click = true;
            drag_lock = true;
            tap-and-drag = true;
          };
        };

        gestures = { };

        device = { };

        group = {
          insert_after_current = true;
          focus_removed_window = true;

          groupbar = {
            enabled = true;
            gradients = true;
            height = 14;
            priority = 3;
            render_titles = true;
            scrolling = true;
          };
        };

        misc = {
          disable_hyprland_logo = true;

          vfr = true;

          mouse_move_enables_dpms = true;
          key_press_enables_dpms = true;

          always_follow_on_dnd = true;
          layers_hog_keyboard_focus = true;

          enable_swallow = true;
          swallow_regex = "^(kitty|footclient|foot)$";
          swallow_exception_regex = "^(nix run nixpkgs##)?(ssh.*|wev|(xorg\.)?xev)$";

          mouse_move_focuses_monitor = true;

          close_special_on_empty = true;
        };

        binds = {
          workspace_back_and_forth = true;
          allow_workspace_cycles = true;
          workspace_center_on = 1;
        };

        env = optionals (!isUWSM) [
          "GDK_BACKEND,wayland,x11,*"
          "QT_QPA_PLATFORM,wayland;xcb"
          "SDL_VIDEODRIVER,wayland"
          "CLUTTER_BACKEND,wayland"

          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "XDG_SESSION_DESKTOP,Hyprland"

          "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          "_JAVA_AWT_WM_NONREPARENTING,1"

          "MOZ_ENABLE_WAYLAND,1"
        ];

        cursor = {
          no_warps = false;
          inactive_timeout = 5;
          default_monitor = "";
        };
      };

      extraConfig = ''
        debug:full_cm_proto=true
      '';
    };

  xdg.configFile."hypr/hyprpaper.conf".text =
    if isNixOS then
      let
        wallpaper = ./imgs/wallpapers/${osConfig.networking.hostName};
      in
      ''
        preload = ${wallpaper}
        wallpaper = , ${wallpaper}
      ''
    else
      '''';
  systemd.user.services.hyprpaper = {
    Unit = {
      Description = "Hyprpaper wallpaper utility for Hyprland";
      After = [ config.wayland.systemd.target ];
    };

    Service = {
      Type = "exec";
      ExecCondition = ''${pkgs.systemd}/lib/systemd/systemd-xdg-autostart-condition "Hyprland" ""'';
      ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
      Restart = "on-failure";
      Slice = "background-graphical.slice";
    };

    Install.WantedBy = [ config.wayland.systemd.target ];
  };

  systemd.user.services.hyprpaper-load = lib.mkIf (!isNixOS) (
    let
      loadWallpaper = pkgs.writeShellScriptBin "loadWallpaper" ''
        set -eo pipefail
        [[ -f ${config.xdg.userDirs.pictures}/Wallpapers/default ]] && WALLPAPER="${config.xdg.userDirs.pictures}/Wallpapers/default"
        [[ -f ${config.xdg.userDirs.pictures}/Wallpapers/`uname -n` ]] && WALLPAPER="${config.xdg.userDirs.pictures}/Wallpapers/`uname -n`"
        [[ -f ${config.xdg.configHome}/wallpaper ]] && WALLPAPER="${config.xdg.configHome}/wallpaper"
        [[ -v WALLPAPER ]] && exec -- ${pkgs.hyprland}/bin/hyprctl hyprpaper reload ,"$WALLPAPER"
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
        lock_cmd = "${pkgs.procps}/bin/pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock --immediate";
        unlock_cmd = "${pkgs.procps}/bin/pkill -USR1 hyprlock";
        before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
        after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        ignore_systemd_inhibit = false;
      };

      listener = [
        {
          timeout = 300; # 5m
          on-timeout = "${pkgs.systemd}/bin/loginctl lock-session";
        }
        {
          timeout = 330; # 5.5m
          on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
          on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
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
        disable_loading_bar = true;
        hide_cursor = true;
        grace = 30;
        no_fade_in = false;
        no_fade_out = false;
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

  systemd.user.services.hyprsunset = rec {
    Service.Slice = "background-graphical.slice";
    Unit.After = Install.WantedBy;
    Install.WantedBy = lib.mkForce [ config.wayland.systemd.target ];
  };
}
