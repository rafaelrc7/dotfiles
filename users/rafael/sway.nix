{ pkgs, lib, ... }: let
  toggle-qt = pkgs.writeShellScriptBin "toggle-qt" ''
    QALCULATE=`pgrep qalculate`
    [ x"$QALCULATE" == "x" ] && ${pkgs.qalculate-qt}/bin/qalculate-qt || kill -s TERM "$QALCULATE"
  '';
in {
  xdg.configFile."sway/wallpaper".source = ./imgs/wallpaper.png;

  home.packages = with pkgs; [
      cliphist
      swaybg
      swaylock
      swayidle
      wl-clipboard
      mako
      grim
      slurp
      wofi
      libnotify
      imv
      glfw-wayland
      waylogout

      font-awesome font-awesome_5
  ];

  wayland.windowManager.sway = let
    terminal    = "${pkgs.foot}/bin/foot";
    browser     = "${pkgs.librewolf}/bin/librewolf";
    fileManager = "${pkgs.dolphin}/bin/dolphin";
    screenlock  = "${pkgs.swaylock}/bin/swaylock -Ffk -c 000000";
    printClip   = "${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - - | ${pkgs.wl-clipboard}/bin/wl-copy";
    calculator  = "${toggle-qt}/bin/toggle-qt";
    mod         = "Mod4";
    alt         = "Mod1";
  in rec {
    enable = true;
    package = null;
    config = rec {
      ## Keyboard ##
      modifier = mod;
      floating.modifier = mod;
      left = "h"; right = "l"; down = "j"; up = "k";
      input = {
        "*" = lib.mkDefault {
          xkb_layout = "br";
          xkb_model = "abnt2";
          xkb_variant = "abnt2";
        };
      };

      ## Startup ##
      startup = [
        { command = "--no-startup-id ${fileManager} --daemon"; }
        { command = "--no-startup-id ${pkgs.swaybg}/bin/swaybg -i ~/.config/sway/wallpaper -m fill"; }
        { command = "--no-startup-id ${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store"; }
      ];

      ## Programs/Addons ##
      inherit terminal;
      menu = "${pkgs.wofi}/bin/wofi --show=drun --insensitive --allow-images --hide-scroll | ${pkgs.findutils}/bin/xargs swaymsg exec --";

      ## Keybindings ##
      keybindings = lib.mkOptionDefault {
        "ctrl+${alt}+l"  = "exec --no-startup-id ${screenlock}";
        "${mod}+Shift+e" = "exec ${pkgs.waylogout}/bin/waylogout";
        "${mod}+q"       = "exec ${browser}";
        "${mod}+e"       = "exec ${fileManager}";
        "${mod}+c"       = "exec ${calculator}";
        "${mod}+p"       = "exec ${pkgs.cliphist}/bin/cliphist list | ${pkgs.wofi}/bin/wofi -p \"Copy\" -dmenu --insensitive --allow-images --hide-scroll | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy";
        "${mod}+shift+p" = "exec ${pkgs.cliphist}/bin/cliphist list | ${pkgs.wofi}/bin/wofi -p \"Delete from history\" -dmenu --insensitive --allow-images --hide-scroll | ${pkgs.cliphist}/bin/cliphist delete";
        "${mod}+alt+p" = "exec ${pkgs.cliphist}/bin/cliphist wipe";
        "Print"          = "exec ${printClip}";

        "${mod}+g"      = "layout toggle split";

        "ctrl+${mod}+space" = "exec ${pkgs.mako}/bin/makoctl dismiss -a";

        "XF86AudioPlay"              = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        "XF86AudioStop"              = "exec ${pkgs.playerctl}/bin/playerctl stop";
        "XF86AudioPrev"              = "exec ${pkgs.playerctl}/bin/playerctl previous";
        "XF86AudioNext"              = "exec ${pkgs.playerctl}/bin/playerctl next";
        "shift+XF86AudioPrev"        = "exec ${pkgs.playerctl}/bin/playerctl position 10-";
        "shift+XF86AudioNext"        = "exec ${pkgs.playerctl}/bin/playerctl position 10+";
        "shift+XF86AudioLowerVolume" = "exec ${pkgs.playerctl}/bin/playerctl volume 0.1-";
        "shift+XF86AudioRaiseVolume" = "exec ${pkgs.playerctl}/bin/playerctl volume 0.1+";

        "${alt}+XF86AudioMute" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

        "XF86AudioMute"        = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioLowerVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioRaiseVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+";

        "XF86MonBrightnessUp"   = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 10%+";
        "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 10%-";
      };

      ## Workspaces ##
      workspaceAutoBackAndForth = true;
      workspaceLayout = "default";

      ## Decorations ##
      gaps = rec {
        smartBorders = "on";
        smartGaps = true;
        inner = 4;
        outer = -inner;
      };

      floating = {
        border = 2;
        titlebar = true;
      };

      window = {
        border = 2;
        titlebar = false;
        hideEdgeBorders = "none";
        commands = [ ];
      };

      fonts = {
        names = [ "FiraCode Nerd Font" ];
        size = 8.0;
      };

      ## Focus ##
      focus = {
        followMouse = true;
        wrapping = "no";
        mouseWarping = true;
        newWindow = "smart";
      };

      ## Program Specifc Settings ##
      floating.criteria = [
        { window_role = "pop-up";      }
        { window_role = "bubble";      }
        { window_role = "task_dialog"; }
        { window_role = "Preferences"; }

        { window_type = "dialog";      }
        { window_type = "menu";        }

        { title = "Qalculate!";        }
      ];

      bars = [{ command = "${pkgs.waybar}/bin/waybar"; }];

    };

    extraConfigEarly = ''
    '';

    extraConfig = ''
    '';

    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
      export CLUTTER_BACKEND="wayland"
      export XDG_SESSION_TYPE="wayland"

      # https://github.com/swaywm/sway/wiki#gtk-applications-take-20-seconds-to-start
      dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK

      # For flatpak to be able to use PATH programs
      sh -c "systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service" &
    '';

    systemd.enable = true;
    wrapperFeatures.gtk = true;
    xwayland = true;
  };

  programs.waybar = {
    enable = true;

    settings = [{
      layer = "bottom";
      position = "top";
      height = 25;
      spacing = 5;

      modules-left   = [ "sway/workspaces" "sway/mode" "sway/scratchpad" "custom/media" ];
      modules-center = [ "sway/window" ];
      modules-right  = [ "tray" "mpd" "idle_inhibitor" "pulseaudio" "network" "cpu" "memory" "temperature" "backlight" "keyboard-state" "sway/language" "battery" "battery#bat2" "clock" ];

      "sway/workspaces" = {
        all-outputs = true;
        format = "{name}{icon}";
        format-icons = {
          "urgent" = " ";
          "focused" = "";
          "default" = "";
        };
      };

      keyboard-state = {
        numlock = true;
        capslock = true;
        format = "{name}{icon}";
        format-icons = {
          locked = "";
          unlocked = "";
        };
      };

      "sway/scratchpad" = {
          format = "{icon} {count}";
          show-empty = false;
          format-icons = ["" ""];
          tooltip = true;
          tooltip-format = "{app}: {title}";
      };

      mpd = {
          format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
          format-disconnected = "Disconnected ";
          format-stopped = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
          unknown-tag = "N/A";
          interval = 2;
          consume-icons = {
              on = " ";
          };
          random-icons = {
              off = "<span color=\"#f53c3c\"></span> ";
              on = " ";
          };
          repeat-icons = {
              on = " ";
          };
          single-icons = {
              on = "1 ";
          };
          state-icons = {
              paused = "";
              playing = "";
          };
          tooltip-format = "MPD (connected)";
          tooltip-format-disconnected = "MPD (disconnected)";
      };

      idle_inhibitor = {
          format = "{icon}";
          format-icons = {
              "activated" = "";
              "deactivated" = "";
          };
      };

      tray = {
          # icon-size = 21;
          spacing = 10;
      };

      clock = {
          timezone = lib.mkDefault "America/Sao_Paulo";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format = "{:%T %d/%m/%Y}";
          interval = 1;
      };

      cpu = {
          format = "{usage}% ";
          tooltip = false;
      };

      memory = {
          format = "{}% ";
      };

      temperature = {
          # "thermal-zone" = 2;
          # "hwmon-path" = "/sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 80;
          # "format-critical" = "{temperatureC}°C {icon}";
          format = "{temperatureC}°C {icon}";
          format-icons = ["" "" ""];
      };

      backlight = {
          # "device" = "acpi_video1";
          format = "{percent}% {icon}";
          format-icons = ["" "" "" "" "" "" "" "" ""];
      };

      battery = {
          states = {
              good = 95;
              warning = 30;
              critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = ["" "" "" "" ""];
      };

      "battery#bat2" = {
          bat = "BAT2";
      };

      network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "";
          tooltip-format = "{ifname} via {gwaddr} at {ipaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
      };

      pulseaudio = {
          scroll-step = 1;
          format = "{volume}% {icon}\t{format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = ["" "" ""];
          };
          on-click = "pavucontrol";
      };
    }];
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "FiraCode Nerd Font Mono:size=11";
        dpi-aware = "no";
      };

      cursor = {
        style = "beam";
        blink = "yes";
      };

      mouse = {
        hide-when-typing = "yes";
      };

      colors = {
        alpha = 0.9;
      };
    };
  };

  services.playerctld.enable = true;

  services.swayidle = {
    enable = true;
    systemdTarget = "sway-session.target";
    timeouts = [
      { timeout = 300; command = "${pkgs.swaylock}/bin/swaylock -Ffk -c 000000"; }
      { timeout = 600; command = "${pkgs.sway}/bin/swaymsg \"output * power off\"";
                       resumeCommand = "${pkgs.sway}/bin/swaymsg \"output * power on\""; }
    ];
    events = [
      { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -Ffk -c 000000"; }
    ];
  };

  services.mako = {
    enable = true;
    actions = true;
    anchor = "top-right";
    icons = true;
    defaultTimeout = 7000; # 7s
    ignoreTimeout = true;
  };

  services.gammastep = {
    enable = true;
    provider = "geoclue2";
    tray = true;
    settings.general = {
      fade = "1";
      adjustment-method = "wayland";
    };
    temperature = {
      day   = 5500;
      night = 2700;
    };
  };

  xdg.configFile."waylogout/config".text = ''
    fade-in=1
    poweroff-command="poweroff"
    reboot-command="reboot"
    logout-command="${pkgs.sway}/bin/swaymsg exit"
    reload-command="${pkgs.sway}/bin/swaymsg reload"
    lock-command="${pkgs.swaylock}/bin/swaylock -Ffk -c 000000"
    default-action="poweroff"
    screenshots
    effect-blur=7x5
    indicator-thickness=20
    ring-color=888888aa
    inside-color=88888866
    text-color=eaeaeaaa
    line-color=00000000
    ring-selection-color=33cc33aa
    inside-selection-color=33cc3366
    text-selection-color=eaeaeaaa
    line-selection-color=00000000
    selection-label
  '';
}

