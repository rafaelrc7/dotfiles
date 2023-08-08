{ config, inputs, pkgs, nixpkgs, home-manager, ... }: {
  networking.hostName = "vulcan";

  imports = [
    ./hardware-configuration.nix
    ./networking.nix
  ];

  environment = {
    systemPackages = with pkgs; [
      dbeaver
      libva-utils
      lutris
      glxinfo
      xclip
      wineWowPackages.staging
      winetricks
      protontricks
      qbittorrent
      zoom
    ];
  };

  programs.java.enable = true;

  services.gnome.gnome-keyring.enable = true;

  console.keyMap = "br-abnt2";
  services.xserver = {
    layout = "br";
    xkbModel = "abnt2";
    xkbVariant = "abnt2";
  };

  services.xserver.videoDrivers = [ "modesetting" ];
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl

        rocm-opencl-icd
        rocm-opencl-runtime
      ];
      extraPackages32 = with pkgs; [
        driversi686Linux.vaapiVdpau
        driversi686Linux.libvdpau-va-gl
      ];
    };
  };

  environment.variables = {
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";
    AMD_VULKAN_ICD = "RADV";
  };

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.hip}"
  ];

  services.xserver = {
    enable = true;

    displayManager = {
      defaultSession = "none+awesome";
      lightdm = {
        enable = true;
        greeters.gtk = {
          enable = true;
          theme = {
            name = "gruvbox-dark";
            package = pkgs.gruvbox-dark-gtk;
          };
          iconTheme = {
            name = "Gruvbox-Dark";
            package = pkgs.gruvbox-dark-icons-gtk;
          };
          cursorTheme = {
            name = "breeze_cursors";
            package = pkgs.libsForQt5.breeze-gtk;
          };
        };
      };
    };
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    extraPackages = with pkgs; [
      swaybg
      swaylock
      swayidle
      wl-clipboard
      mako
      grim
      slurp
      wofi
      libnotify
      imv
      glfw-wayland
      waylogout
    ];

    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
      export CLUTTER_BACKEND="wayland";
      export XDG_SESSION_TYPE="wayland";

      # Flatpak
      systemctl --user import-environment PATH
    '';
  };

  security.polkit.enable = true;

  xdg.portal= {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
      xdg-desktop-portal-kde
    ];

    xdgOpenUsePortal = true;
  };

  services.postgresql = {
    enable = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all peer
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
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

