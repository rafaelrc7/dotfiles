{ config, inputs, pkgs, nixpkgs, home-manager, ... }: {
  networking.hostName = "spitfire";

  boot.kernel.sysctl."kernel.sysrq" = 1;

  imports = [
    ./hardware-configuration.nix
    ./networking.nix
  ];

  environment = {
    systemPackages = with pkgs; [
      brightnessctl
      mons
      lutris
      libva-utils
      glxinfo
      wineWowPackages.staging
      winetricks
      xclip
      qbittorrent
      zoom
    ];
  };

  programs.java.enable = true;

  services.gnome.gnome-keyring.enable = true;

  services.xserver = {
    enable = false;

    displayManager = {
      defaultSession = "none+awesome";
      lightdm = {
        enable = false;
        greeters.gtk = {
          enable = true;
          theme = {
            name = "Dracula";
            package = pkgs.dracula-theme;
          };
          iconTheme = {
            name = "Dracula";
            package = pkgs.dracula-icon-theme;
          };
          cursorTheme = {
            name = "breeze_cursors";
            package = pkgs.libsForQt5.breeze-qt5;
          };
        };
      };
    };
  };

  programs.sway = {
    enable = true;
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    extraSessionCommands = ''
      [ -e $HOME/.zshenv ] && . $HOME/.zshenv
      [ -e $HOME/.profile ] && . $HOME/.profile

      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
      export CLUTTER_BACKEND="wayland"
      export XDG_SESSION_TYPE="wayland"

      export TERMINAL="foot"

      # For flatpak to be able to use PATH programs
      sh -c "systemctl --user import-environment PATH" &
    '';
  };
  security.polkit.enable = true;
  security.pam.services.swaylock = {};
  services.dbus.enable = true;

  xdg.portal= {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];

    xdgOpenUsePortal = true;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services = {
    printing = {
      enable = true;
      drivers = [ pkgs.epson-escpr pkgs.epson_201207w ];
      browsing = true;
      startWhenNeeded = true;
    };

    avahi = {
      enable = true;
      nssmdns = true;
      publish.enable = true;
      publish.addresses = true;
      publish.userServices= true;
    };
  };

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.epson-escpr ];
  };

  programs.dconf.enable = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "qt";
  };

  systemd.services.brightness = {
    enable = true;
    script = ''
      ${pkgs.brightnessctl}/bin/brightnessctl set 30%
    '';
    wantedBy = [ "multi-user.target" ];
  };

  system.stateVersion = "22.11";
}

