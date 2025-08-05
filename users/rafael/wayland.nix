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
    flameshot
    glfw-wayland
    grim
    libnotify
    mako
    slurp
    wdisplays
    wl-clipboard
  ];

  xdg.configFile."menus/applications.menu".text =
    builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

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
