{ config, lib, pkgs, ... }:
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

  services.wlsunset = {
    enable = true;
    temperature = {
      day = 6500;
      night = 2700;
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

