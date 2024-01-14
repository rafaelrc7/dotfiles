{ self, ... }: with self.nixosModules;
{ config, inputs, pkgs, nixpkgs, home-manager, ... }: {
  networking.hostName = "spitfire";

  boot.kernel.sysctl."kernel.sysrq" = 1;

  imports = with inputs; [
    ./hardware-configuration.nix
    ./networking.nix

    common
    android
    boot
    btrfs
    flatpak
    geoclue
    nix
    pipewire
    zsh
    fonts
    cryptswap
    man
    mullvad
    ssh
    git
    polkit
    udev-media-keys
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-pc-laptop
  ];

  environment = {
    systemPackages = with pkgs; [
      brightnessctl
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
      nssmdns4 = true;
      openFirewall = true;
      publish.enable = true;
      publish.addresses = true;
      publish.userServices= true;
    };
  };

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan pkgs.epkowa ];
    disabledDefaultBackends = [ "v4l" "epson2" ];
  };
  services.ipp-usb.enable = true;

  hardware.printers = {
    ensureDefaultPrinter = "L355-Series";
    ensurePrinters = [
      {
        name = "L355-Series";
        location = "office";
        deviceUri = "usb://EPSON/L355%20Series?serial=53335A4B3039313191&interface=1";
        model = "epson-inkjet-printer-201207w/ppds/EPSON_L355.ppd";
        ppdOptions = {
          MediaType = "PLAIN";
          PrintQuality = "High";
          PageSize = "A4";
          OutputPaper = "A4";
          Color = "Grayscale";
        };
      }
    ];
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

