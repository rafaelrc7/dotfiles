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
    glfw
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
    layout =
      let
        loginctl = lib.getExe' pkgs.systemd "loginctl";
        systemctl = lib.getExe' pkgs.systemd "systemctl";
        systemd-run = lib.getExe' pkgs.systemd "systemd-run";
        run =
          label: cmds:
          let
            label' = "wlogout-${label}";
          in
          "${systemd-run} --user --collect --unit=${label'} ${pkgs.writeShellScript label' cmds}";
        run-hyprshutdown = label: cmd: run label "${lib.getExe pkgs.hyprshutdown} && ${cmd}";
      in
      [
        {
          label = "lock";
          action = "${loginctl} lock-session";
          text = "Lock";
          keybind = "l";
        }
        {
          label = "hibernate";
          action = "${systemctl} hibernate";
          text = "Hibernate";
          keybind = "h";
        }
        {
          label = "logout";
          action = run-hyprshutdown "logout" /* sh */ "${loginctl} terminate-user $USER";
          text = "Logout";
          keybind = "e";
        }
        {
          label = "shutdown";
          action = run-hyprshutdown "shutdown" /* sh */ "${systemctl} poweroff";
          text = "Shutdown";
          keybind = "s";
        }
        {
          label = "suspend";
          action = "${systemctl} suspend";
          text = "Suspend";
          keybind = "u";
        }
        {
          label = "reboot";
          action = run-hyprshutdown "reboot" /* sh */ "${systemctl} reboot";
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

        savePath = "${config.xdg.userDirs.pictures}/Screenshots";
        copyPathAfterSave = true;
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
    systemdTarget = config.wayland.systemd.target;
    settings = {
      verbosity = "INFO";
      media_minimum_duration = 10;
      node_blacklist = [
        { name = "spotify"; }
        { app_name = "Music Player Daemon"; }
      ];
    };
  };
  systemd.user.services.wayland-pipewire-idle-inhibit.Service.Slice = "background-graphical.slice";
}
