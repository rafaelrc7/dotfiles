{ inputs, config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    cliphist
    dolphin
    glfw-wayland
    grim
    imv
    libnotify
    mako
    slurp
    waylogout
    wdisplays
    wl-clipboard
    wofi
  ];

  home.file."${config.xdg.userDirs.pictures}/Wallpapers" = {
    recursive = true;
    source = ./imgs/wallpapers;
  };

  xdg.configFile."waylogout/config".text = ''
    fade-in=1
    poweroff-command="poweroff"
    reboot-command="reboot"
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

  services.cliphist = {
    enable = true;
    allowImages = true;
    systemdTarget = "wayland.target";
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        dpi-aware = "no";
      };

      cursor = {
        style = "beam";
        blink = "yes";
      };

      mouse = {
        hide-when-typing = "yes";
      };
    };
  };

  services.wlsunset = {
    enable = true;
    systemdTarget = "wayland.target";
    temperature = {
      day = 6500;
      night = 2700;
    };
    sunrise = "06:00";
    sunset = "17:30";
  };

  services.mako = {
    enable = true;
    actions = true;
    anchor = "top-right";
    icons = true;
    defaultTimeout = 7000; # 7s
    ignoreTimeout = true;
  };

  services.playerctld.enable = true;

  services.wayland-pipewire-idle-inhibit = {
    enable = true;
    systemdTarget = "wayland.target";
    settings = {
      verbosity = "INFO";
      media_minimum_duration = 10;
      node_blacklist = [
        { name = "spotify"; }
        { app_name = "Music Player Daemon"; }
      ];
    };
  };

  systemd.user.targets = {
    wayland = {
      Install = {
        WantedBy = [ "sway-session.target" "hyprland-session.target" ];
      };
      Unit = {
        Description = "Wayland compositor session";
        After = [ "sway-session.target" "hyprland-session.target" ];
      };
    };
  };
}

