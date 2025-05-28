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
    kdePackages.dolphin
    kdePackages.konsole
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
        terminal = "${pkgs.kitty}/bin/kitty";
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

  services.hyprsunset = {
    enable = true;
    extraArgs = [ "--identity" ];
  };
  systemd.user.services.hyprsunset = rec {
    Service.Slice = "background-graphical.slice";
    Unit.After = Install.WantedBy;
    Install.WantedBy = lib.mkForce [
      config.wayland.systemd.target
    ];
  };

  systemd.user.services."hyprsunset-manager" = rec {
    Unit = {
      Description = "Manage Hyprsunset";
      Wants = Install.WantedBy;
      After = Install.WantedBy;
    };

    Service = {
      Type = "simple";
      Restart = "always";
      RestartSec = 30;
      ExecStart = lib.getExe (
        pkgs.writeShellApplication {
          name = "hyprsunset-manager";
          runtimeInputs = with pkgs; [
            dateutils
            jq
            socat
          ];
          text = builtins.readFile ./hyprsunset-manager.sh;
        }
      );
    };

    Install.WantedBy = [ "hyprsunset.service" ];
  };

  services.mako = {
    enable = true;
    settings = {
      actions = true;
      anchor = "top-right";
      default-timeout = 7000; # 7s
      icons = true;
      ignore-timeout = true;
    };
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
  systemd.user.services.wayland-pipewire-idle-inhibit = {
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
