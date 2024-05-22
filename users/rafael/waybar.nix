{ config, pkgs, lib, ... }: {

  home.packages = with pkgs; [
    font-awesome
    roboto
    roboto-mono
  ];

  wayland.windowManager.sway.config.bars = [ ];

  programs.waybar = {
    enable = true;

    systemd = {
      enable = true;
      target = "wayland.target";
    };

    settings = [{
      layer = "bottom";
      position = "top";

      modules-left = [ "sway/workspaces" "hyprland/workspaces" "sway/mode" "hyprland/submap" "sway/scratchpad" "sway/window" "hyprland/window" ];

      modules-center = [ "clock" ];

      modules-right = [
        "tray"
        "mpd"
        "pulseaudio"
        "privacy"
        "network"
        "cpu"
        "memory"
        "temperature"
        "battery"
        "idle_inhibitor"
        "backlight"
        "sway/language"
      ];

      "sway/workspaces" = {
        all-outputs = true;
        format = "{name}{icon}";
        format-icons = {
          urgent = " ";
          focused = "";
          default = "";
        };
      };

      "hyprland/workspaces" = {
        all-outputs = true;
        format = "{name}{icon}";
        format-icons = {
          urgent = " ";
          focused = "";
          default = "";
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
        format-icons = [ "" "" ];
        tooltip = true;
        tooltip-format = "{app}: {title}";
      };

      mpd = {
        format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ";
        format-disconnected = "Disconnected ";
        format-stopped = " {consumeIcon}{randomIcon}{repeatIcon}{singleIcon} ";
        unknown-tag = "N/A";
        interval = 2;
        consume-icons = {
          on = " ";
        };
        random-icons = {
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
          activated = "";
          deactivated = "";
        };
      };

      tray = {
        # icon-size = 21;
        spacing = 10;
      };

      clock = {
        format = "  {:%T     %a %d/%m/%Y}";
        timezone = lib.mkDefault "America/Sao_Paulo";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
        calendar = {
          mode = "year";
          mode-mon-col = 3;
          weeks-pos = "right";
          on-scroll = 1;
          format = {
            months = "<span color='#ffead3'><b>{}</b></span>";
            days = "<span color='#ecc6d9'><b>{}</b></span>";
            weeks = "<span color='#99ffdd'><b>W{}</b></span>";
            weekdays = "<span color='#ffcc66'><b>{}</b></span>";
            today = "<span color='#ff6699'><b><u>{}</u></b></span>";
          };
        };

        actions = {
          on-click-right = "mode";
          on-click-forward = "tz_up";
          on-click-backward = "tz_down";
          on-scroll-up = "shift_up";
          on-scroll-down = "shift_down";
        };
        interval = 1;
      };

      cpu = {
        format = " {usage}%";
        tooltip = false;
      };

      memory = {
        format = " {}%";
      };

      temperature = {
        critical-threshold = 80;
        format = "{temperatureC}°C {icon}";
        format-icons = [ "" "" "" ];
        hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:18.3/hwmon";
        input-filename = "temp1_input";
      };

      backlight = {
        # "device" = "acpi_video1";
        format = "{icon} {percent}%";
        format-icons = [ "" "" "" "" "" "" "" "" "" ];
      };

      battery = {
        states = {
          good = 95;
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-charging = " {capacity}%";
        format-plugged = " {capacity}%";
        format-alt = "{icon} {time}";
        format-icons = [ "" "" "" "" "" ];
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
        format = "{icon} {volume}%  {format_source}";
        format-bluetooth = "{icon} {volume}%  {format_source}";
        format-bluetooth-muted = " {icon}  {format_source}";
        format-muted = "   {format_source}";
        format-source = " {volume}%";
        format-source-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [ "" "" "" ];
        };
        on-click = "pavucontrol";
      };

      privacy = {
        icon-spacing = 4;
        icon-size = 17;
        transition-duration = 250;
        modules = [
          {
            type = "screenshare";
            tooltip = true;
            tooltip-icon-size = 24;
          }
          {
            type = "audio-out";
            tooltip = true;
            tooltip-icon-size = 24;
          }
          {
            type = "audio-in";
            tooltip = true;
            tooltip-icon-size = 24;
          }
        ];
      };

      "sway/language" = {
        format = "  {shortDescription} {short} {variant}";
        on-click = "swaymsg input type:keyboard xkb_switch_layout next";
        on-click-right = "swaymsg input type:keyboard xkb_switch_layout previous";
        on-click-middle = "swaymsg input type:keyboard xkb_switch_layout 0";
        tooltip-format = "{long}";
      };

      "hyprland/language" = {
        format = "  {}";
        format-en = "en us";
        format-pt = "pt br";
      };
    }];

  };
}

