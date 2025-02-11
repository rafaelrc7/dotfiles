{
  config,
  lib,
  pkgs,
  ...
}:
{
  wayland.systemd.target = "graphical-session.target";

  home.packages = with pkgs; [
    cliphist
    dolphin
    flameshot
    glfw-wayland
    grim
    libnotify
    mako
    slurp
    wdisplays
    wl-clipboard
  ];

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.foot}/bin/foot";
      };
    };
  };

  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "loginctl lock-session";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
      {
        label = "logout";
        action = "loginctl terminate-user $USER";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
    ];
  };

  home.file."${config.xdg.userDirs.pictures}/Wallpapers" = {
    recursive = true;
    source = ./imgs/wallpapers;
  };

  home.sessionVariables.NIXOS_OZONE_WL = "1";

  services.cliphist = {
    enable = true;
    allowImages = true;
  };

  systemd.user.services.cliphist = rec {
    Service.Slice = "background-graphical.slice";
    Unit.After = Install.WantedBy;
    Install.WantedBy = lib.mkForce [
      config.wayland.systemd.target
    ];
  };
  systemd.user.services.cliphist-images = rec {
    Service.Slice = "background-graphical.slice";
    Unit.After = Install.WantedBy;
    Install.WantedBy = lib.mkForce [
      config.wayland.systemd.target
    ];
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

  programs.imv.enable = true;

  services.flameshot = {
    enable = true;
    settings = {
      General = {
        showStartupLaunchMessage = false;
        disabledGrimWarning = true;
      };
    };
  };

  services.wlsunset = {
    enable = true;
    temperature = {
      day = 6500;
      night = 4000;
    };
    sunrise = "06:00";
    sunset = "17:30";
  };
  systemd.user.services.wlsunset = rec {
    Service.Slice = "background-graphical.slice";
    Unit.After = Install.WantedBy;
    Install.WantedBy = lib.mkForce [
      config.wayland.systemd.target
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

  services.playerctld.enable = true;

  services.wayland-pipewire-idle-inhibit = {
    enable = true;
    settings = {
      verbosity = "INFO";
      media_minimum_duration = 10;
      node_blacklist = [
        { name = "spotify"; }
        { app_name = "Music Player Daemon"; }
      ];
    };
  };
  systemd.user.services.wayland-pipewire-idle-inhibit = rec {
    Service.Slice = "background-graphical.slice";
    Unit.After = lib.mkForce [
      config.wayland.systemd.target
      "pipewire.service"
    ];
    Install.WantedBy = lib.mkForce [
      config.wayland.systemd.target
    ];
  };
}
