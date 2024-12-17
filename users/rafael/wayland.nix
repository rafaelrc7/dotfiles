{ config, lib, pkgs, ... }:
{
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
    wofi
  ];

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
  systemd.user.services.cliphist.Install.WantedBy = lib.mkForce [ "sway-session.target" "hyprland-session.target" ];
  systemd.user.services.cliphist-images.Install.WantedBy = lib.mkForce [ "sway-session.target" "hyprland-session.target" ];

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
  systemd.user.services.wlsunset.Install.WantedBy = lib.mkForce [ "sway-session.target" "hyprland-session.target" ];

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
  systemd.user.services.wayland-pipewire-idle-inhibit.Install.WantedBy = lib.mkForce [ "sway-session.target" "hyprland-session.target" ];

}

