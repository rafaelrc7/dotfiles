{ config, inputs, pkgs, nixpkgs, home-manager, ... }: {
  networking.hostName = "vulcan";

  imports = [
    ./hardware-configuration.nix
    ./networking.nix
  ];

  environment = {
    systemPackages = with pkgs; [
      libva-utils
      lutris
      glxinfo
      xclip
    ];
  };

  console.keyMap = "br-abnt2";
  services.xserver = {
    layout = "br";
    xkbModel = "abnt2";
    xkbVariant = "abnt2";
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
    };
  };

  services.flatpak.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  services.xserver = {
    enable = true;

    displayManager = {
      defaultSession = "none+awesome";
      lightdm = {
        enable = true;
        greeters.gtk = {
          enable = true;
          theme = {
            name = "Nordic-darker";
            package = pkgs.nordic;
          };
          iconTheme = {
            name = "Arc";
            package = pkgs.arc-icon-theme;
          };
          cursorTheme = {
            name = "breeze_cursors";
            package = pkgs.libsForQt5.breeze-gtk;
          };
        };
      };
    };
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

  system.stateVersion = "22.05";
}

