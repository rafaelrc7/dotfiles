{ inputs, config, pkgs, lib, ... }:
let
  loadWallpaper = pkgs.writeShellScriptBin "loadWallpaper" ''
    set -eo pipefail
    [[ -f ${config.xdg.userDirs.pictures}/Wallpapers/default ]] && WALLPAPER="${config.xdg.userDirs.pictures}/Wallpapers/default"
    [[ -f ${config.xdg.userDirs.pictures}/Wallpapers/`uname -n` ]] && WALLPAPER="${config.xdg.userDirs.pictures}/Wallpapers/`uname -n`"
    [[ -f ${config.xdg.configHome}/wallpaper ]] && WALLPAPER="${config.xdg.configHome}/wallpaper"
    [[ -v WALLPAPER ]] && exec -- ${pkgs.swaybg}/bin/swaybg -i "$WALLPAPER" -m fill
    exit 0
  '';
in
{
  imports = [
    ./waybar.nix
    ./wayland.nix
  ];

  home.packages = with pkgs; [
    hyprland
    hypridle
    hyprlock
    hyprpaper
  ];

  wayland.windowManager.hyprland =
    let
      menu = "${pkgs.procps}/bin/pkill wofi || ${pkgs.wofi}/bin/wofi --show=drun --insensitive --allow-images --hide-scroll";
      terminal = "${pkgs.foot}/bin/foot";
      browser = "${pkgs.librewolf}/bin/librewolf";
      fileManager = "${pkgs.dolphin}/bin/dolphin";
      screenlock = "${pkgs.hyprlock}/bin/hyprlock";
      printClip = "${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - - | ${pkgs.wl-clipboard}/bin/wl-copy";
      calculator = "${pkgs.procps}/bin/pkill qalculate-qt || ${pkgs.qalculate-qt}/bin/qalculate-qt";
    in
    {
      enable = true;

      systemd = {
        enable = true;
        enableXdgAutostart = true;
        variables = [ "--all" ];
      };

      xwayland.enable = true;

      importantPrefixes = [ ];

      settings = {
        monitor = [
          "HDMI-A-1, preferred, 0x0,    1"
          "DP-3,     preferred, 2560x0, 1"
          ",         preferred, auto,   1"
        ];

        "$mod" = "SUPER";

        exec-once = [
          "${loadWallpaper}/bin/loadWallpaper"
        ];

        bind = [
          # Apps
          "$mod, RETURN, exec, ${terminal}"
          "$mod, D, exec, ${menu}"
          "$mod, Q, exec, ${browser}"
          "$mod, E, exec, ${fileManager}"
          "$mod, C, exec, ${calculator}"

          # Screenshot
          ", Print, exec, ${printClip}"

          # Clear notifications
          "$mod + CTRL, SPACE, exec, ${pkgs.mako}/bin/makoctl dismiss -a"

          # Toggle waybar
          "$mod, B, exec, ${pkgs.killall}/bin/killall -s SIGUSR1 -r waybar"

          # Fullscreen / maximise
          "$mod, F, fullscreen, 0"
          "$mod, M, fullscreen, 1"
          "$mod + SHIFT, F, fullscreen, 2"

          # Close active
          "$mod + SHIFT, Q, killactive"

          # Sticky
          "$mod + SHIFT, S, pin"

          # Toggle floating
          "$mod + SHIFT, SPACE, togglefloating"

          # Exit/logout
          # TODO: logout screen
          "$mod + SHIFT, E, exit"
          "$mod + CTRL, L, exec, ${screenlock} --immediate"

          # Clipboard manager
          "$mod, P, exec, ${pkgs.cliphist}/bin/cliphist list | ${pkgs.wofi}/bin/wofi -p \"Copy\" -dmenu --insensitive --allow-images --hide-scroll | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy"
          "$mod + SHIFT, P, exec, ${pkgs.cliphist}/bin/cliphist list | ${pkgs.wofi}/bin/wofi -p \"Delete from history\" -dmenu --insensitive --allow-images --hide-scroll | ${pkgs.cliphist}/bin/cliphist delete"
          "$mod + ALT, P, exec, ${pkgs.cliphist}/bin/cliphist wipe"

          # Brightness
          ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 10%+"
          ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 10%-"

          # Audio
          "SHIFT, XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

          # Global binds
          ",Pause,pass,^(discord)$"

          # Tab windows
          "$mod, T, togglegroup"

          # Dwindle
          "$mod, O, pseudo,"
          "$mod, S, togglesplit"
          "$mod + CTRL, H, layoutmsg, preselect, l"
          "$mod + CTRL, J, layoutmsg, preselect, d"
          "$mod + CTRL, K, layoutmsg, preselect, u"
          "$mod + CTRL, L, layoutmsg, preselect, r"

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
        ];

        bindel = [
          # Global Volume
          ", XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"

          # App Volume
          "ALT, XF86AudioRaiseVolume, exec, ${pkgs.playerctl}/bin/playerctl volume 0.1+"
          "ALT, XF86AudioLowerVolume, exec, ${pkgs.playerctl}/bin/playerctl volume 0.1-"
        ];

        bindl = [
          # Mute
          ", XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

          # Media keys
          ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
          ", XF86AudioStop, exec, ${pkgs.playerctl}/bin/playerctl stop"
          ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
          ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"

          "SHIFT, XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl position 10-"
          "SHIFT, XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl position 10+"
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
          no_gaps_when_only = 1;
        };

        master = {
          new_is_master = true;
        };

        decoration = {
          rounding = 5;

          active_opacity = 1.0;
          inactive_opacity = 1.0;
          fullscreen_opacity = 1.0;

          drop_shadow = true;
          shadow_range = 4;
          shadow_render_power = 3;
          shadow_offset = "0 0";
          shadow_scale = "1.0";

          dim_inactive = false;

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
          vfr = true;

          mouse_move_enables_dpms = true;
          key_press_enables_dpms = true;

          always_follow_on_dnd = true;
          layers_hog_keyboard_focus = true;

          enable_swallow = true;
          swallow_regex = "^(kitty|footclient|foot)$";

          no_direct_scanout = false;

          mouse_move_focuses_monitor = true;

          close_special_on_empty = true;
        };

        binds = {
          workspace_back_and_forth = true;
          allow_workspace_cycles = true;
          workspace_center_on = 1;
        };

        windowrulev2 = [
          "float,class:^(io.github.Qalculate.qalculate-qt)$"
        ];

        env = [
          "GDK_BACKEND,wayland,x11"
          "QT_QPA_PLATFORM,wayland;xcb"
          "SDL_VIDEODRIVER,wayland"
          "CLUTTER_BACKEND,wayland"

          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "XDG_SESSION_DESKTOP,Hyprland"

          "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          "_JAVA_AWT_WM_NONREPARENTING,1"

          "MOZ_ENABLE_WAYLAND,1"

          "TERMINAL,foot"
          "EXPLORER,dolphin"
        ];

        cursor = {
          no_warps = false;
          inactive_timeout = 5;
          default_monitor = "";
        };
      };

      extraConfig = ''

    '';
    };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "${pkgs.hyprlock}/bin/hyprlock --immediate";
        ignore_systemd_inhibit = false;
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "${pkgs.hyprlock}/bin/hyprlock";
        }
        {
          timeout = 600;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
  systemd.user.services.hypridle.Install.WantedBy = lib.mkForce [ "hyprland-session.target" ];

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
        grace = 60;
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

      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          outline_thickness = 5;
          placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
          shadow_passes = 2;
        }
      ];
    };
  };

}

